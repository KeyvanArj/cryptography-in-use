from asn1crypto import cms, util, core, x509, pem
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.serialization import pkcs12, Encoding
from cryptography.exceptions import InvalidSignature

#from bitstring import BitArray;

class CryptoObject:

    def __init__(self) :
        pass

    def load_private_key(self, pfx_file_path, pfx_file_password):

        # open it, using password. Supply/read your own from stdin.
        with open(pfx_file_path, "rb") as key_file:
            (self.private_key,
             certificate,
             certificates) = pkcs12.load_key_and_certificates(key_file.read(), password=pfx_file_password)
        
        _, _, pem_bytes = pem.unarmor(certificate.public_bytes(Encoding.PEM))
        self.certificate = x509.Certificate.load(pem_bytes)
        
        pass

    def sign(self, byte_array_data) :
        
        # Creating a SignedData object from cms
        signed_data = cms.SignedData()

        # Populating some of its fields
        signed_data['version'] = 'v1'
        signed_data['encap_content_info'] = util.OrderedDict([('content_type', 'data'), ('content', byte_array_data)])
        signed_data['digest_algorithms'] = [util.OrderedDict([('algorithm', 'sha256'), ('parameters', None)])]

        # Adding this certificate to SignedData object
        signed_data['certificates'] = [self.certificate]
        print('certificate version : ', self.certificate.native)

        # Setting signer info section
        signer_info = cms.SignerInfo()
        signer_info['version'] = 'v3'
        signer_info['digest_algorithm']=util.OrderedDict([('algorithm', 'sha256'), ('parameters', None) ])
        signer_info['signature_algorithm']=util.OrderedDict([('algorithm', 'sha256_rsa'), ('parameters', None) ])

        # Creating a signature using a private key object
        signature = self.private_key.sign(byte_array_data, 
                                         padding.PKCS1v15(),
                                         hashes.SHA256()
                                        )
        signer_info['signature'] = signature

        # Finding subject_key_identifier from certificate (asn1crypto.x509 object)
        signer_identifier = cms.IssuerAndSerialNumber()
        signer_identifier['issuer'] = self.certificate.issuer
        signer_identifier['serial_number'] = core.Integer(self.certificate.serial_number)
        signer_info['sid'] = signer_identifier

        # Adding SignerInfo object to SignedData object
        signed_data['signer_infos'] = [ signer_info ]

        # Writing everything into ASN.1 object
        content_info = cms.ContentInfo()
        content_info['content_type'] = 'signed_data'
        content_info['content'] = signed_data

        return content_info.dump()

    def cryptography_x509_name_to_asn1crypto_x509_name(self, cryptography_x509_name):
        name_dict = dict()
        for attribute in cryptography_x509_name:
            name_dict.update({attribute.oid.dotted_string : attribute.value})

        asn1crypto_x509_name = x509.Name.build(name_dict)
        
        return asn1crypto_x509_name
