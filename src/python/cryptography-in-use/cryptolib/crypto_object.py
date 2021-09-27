import hashlib
import base64

from asn1crypto import cms, util, core, x509, pem
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives.padding import PKCS7
from cryptography.hazmat.primitives import hashes
from OpenSSL import crypto
from asn1crypto import x509, core, pem, cms
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

#from bitstring import BitArray;

class CryptoObject:

    def __init__(self) :
        pass

    def encrypt_aes256_cbc_pkcs5(self, plainBytes, keyBase64, ivBase64) :
        key = base64.b64decode(keyBase64)
        iv = base64.b64decode(ivBase64)
        padder = PKCS7(128).padder()
        padded_data = padder.update(plainBytes)
        padded_data += padder.finalize()
        cipher = Cipher(algorithms.AES(key), modes.CBC(iv))
        encryptor = cipher.encryptor()
        ciphered_data = encryptor.update(padded_data) + encryptor.finalize()
        return iv + ciphered_data    
        

    def sign(self, keypair, byte_array_data) :
        
        # Creating a SignedData object from cms
        signed_data = cms.SignedData()

        # Populating some of its fields
        signed_data['version'] = 'v1'
        signed_data['encap_content_info'] = util.OrderedDict([('content_type', 'data'), ('content', byte_array_data)])
        signed_data['digest_algorithms'] = [util.OrderedDict([('algorithm', 'sha256'), ('parameters', None)])]

        # Adding this certificate to SignedData object
        signed_data['certificates'] = [keypair.certificate]
       
        # Setting signer info section
        signer_info = cms.SignerInfo()
        signer_info['version'] = 'v3'
        signer_info['digest_algorithm']=util.OrderedDict([('algorithm', 'sha256'), ('parameters', None) ])
        signer_info['signature_algorithm']=util.OrderedDict([('algorithm', 'sha256_rsa'), ('parameters', None) ])

        # Creating a signature using a private key object
        signature = keypair.private_key.sign(byte_array_data, 
                                             padding.PKCS1v15(),
                                            hashes.SHA256()
                                            )
        signer_info['signature'] = signature

        # Finding subject_key_identifier from certificate (asn1crypto.x509 object)
        signer_identifier = cms.IssuerAndSerialNumber()
        signer_identifier['issuer'] = keypair.certificate.issuer
        signer_identifier['serial_number'] = core.Integer(keypair.certificate.serial_number)
        signer_info['sid'] = signer_identifier

        # Adding SignerInfo object to SignedData object
        signed_data['signer_infos'] = [ signer_info ]

        # Writing everything into ASN.1 object
        content_info = cms.ContentInfo()
        content_info['content_type'] = 'signed_data'
        content_info['content'] = signed_data

        return content_info.dump()

    def verify_cms(self, cms_data, signed_data):
    
        # Verify hash embedded in cms
        cms_content = cms.ContentInfo.load(cms_data)['content']

        digest_algorithm = cms_content['digest_algorithms'][0]['algorithm'].native
        attributes = cms_content['signer_infos'][0]['signed_attrs']
        cms_signing_time = None
        digest_result = getattr(hashlib, digest_algorithm)(signed_data).digest()
        if attributes is not None and not isinstance(attributes, core.Void):
            cms_hash = None
            for attribute in attributes:
                if attribute['type'].native == 'message_digest':
                    cms_hash = attribute['values'].native[0]
                if attribute['type'].native == 'signing_time':
                    cms_signing_time = attribute['values'].native[0]     
            cms_signed_data = attributes.dump()
            cms_signed_data = b'\x31' + cms_signed_data[1:]
        else:
            cms_hash = digest_result
            cms_signed_data = signed_data
        
        cms_hash_verfication = (digest_result == cms_hash)

        # Verify signature embedded in cms
        signature = cms_content['signer_infos'][0]['signature'].native
        serial = cms_content['signer_infos'][0]['sid'].native['serial_number']
        public_key = None
        not_before = None
        not_after = None
        for certificate in cms_content['certificates']:
            if serial == certificate.native['tbs_certificate']['serial_number']:
                certificate = certificate.dump()
                certificate = pem.armor(u'CERTIFICATE', certificate)
                certificate = crypto.load_certificate(crypto.FILETYPE_PEM, certificate)
                public_key = certificate.get_pubkey().to_cryptography_key()
                not_before = certificate.get_notBefore().decode()
                not_after = certificate.get_notAfter().decode()
                break

        signature_algorithm = cms_content['signer_infos'][0]['signature_algorithm']
        signature_algorithm_name = signature_algorithm.signature_algo
        if signature_algorithm_name == 'rsassa_pss':
            parameters = signature_algorithm['parameters']
            signature_hash_algorithm = parameters['hash_algorithm'].native['algorithm'].upper()
            mgf = getattr(padding, parameters['mask_gen_algorithm'].native['algorithm'].upper())(getattr(hashes, signature_hash_algorithm)())
            salt_length = parameters['salt_length'].native
            try:
                public_key.verify(
                    signature,
                    cms_signed_data,
                    padding.PSS(mgf, salt_length),
                    getattr(hashes, signature_hash_algorithm)()
                )
                cms_signature_verfication = True
            except:
                cms_signature_verfication = False
        elif signature_algorithm_name == 'rsassa_pkcs1v15':
            try:
                public_key.verify(
                    signature,
                    cms_signed_data,
                    padding.PKCS1v15(),
                    getattr(hashes, digest_algorithm.upper())()
                )
                cms_signature_verfication = True
            except:
                cms_signature_verfication = False
        else:
            raise ValueError('Unknown signature algorithm')

        # extract certificates
        cms_certificates = []
        for certificate in cms_content['certificates']:
            certificate_data = pem.armor(u'CERTIFICATE', certificate.dump()).decode()
            cms_certificates.append(certificate_data)
    
        # verify signing time
        signing_time = cms_signing_time.strftime('%Y%m%d%H%M%SZ')
        signing_time_verification = (not_before <= signing_time <= not_after)
        # print('Signing Time : ', signing_time)        
        # print('Not Before : ', not_before)
        # print('Not After : ', not_after)

        return (cms_hash_verfication, 
                cms_signature_verfication, 
                signing_time_verification, 
                cms_certificates) 

    def cryptography_x509_name_to_asn1crypto_x509_name(self, cryptography_x509_name):
        name_dict = dict()
        for attribute in cryptography_x509_name:
            name_dict.update({attribute.oid.dotted_string : attribute.value})

        asn1crypto_x509_name = x509.Name.build(name_dict)
        
        return asn1crypto_x509_name
