import hashlib

from OpenSSL import crypto
from asn1crypto import x509, core, pem, cms
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import padding

class CryptoPdf :

    def __init__(self):
        pass

    def verify_document(self, pdf_file, certificate_file):

        # Read binary stream of pdf file and certificate
        pdf_data = pdf_file.read()
        certificate_data = certificate_file.read()

        # Extract the content and signed data of pdf
        (cms_data, signed_data) = self.extract_signature_data(pdf_data)

        # Load certificates
        self.load_certificate(certificate_data)

        # verify the hash of signed data by which is included in cms_data
        # and the signature emdedded in cms_data 
        (cms_hash_verfication, cms_signature_verfication)  = self.verify_cms(cms_data, signed_data)

        return (cms_hash_verfication, cms_signature_verfication)

    def extract_signature_data(self, pdf_data):
        
        index = pdf_data.find(b"/ByteRange")
        start = pdf_data.find(b"[", index)
        stop = pdf_data.find(b"]", start)
        assert index != -1 and start != -1 and stop != -1
        
        br = [int(i, 10) for i in pdf_data[start + 1 : stop].split()]
        
        cms_data = pdf_data[br[0] + br[1] + 1 : br[2] - 1]
        cms_bytes = bytes.fromhex(cms_data.decode("utf8"))
        
        data1 = pdf_data[br[0] : br[0] + br[1]]
        data2 = pdf_data[br[2] : br[2] + br[3]]
        signed_data = data1 + data2

        return (cms_bytes, signed_data)

    def verify_cms(self, cms_data, signed_data):

        # Verify hash embedded in cms
        cms_content = cms.ContentInfo.load(cms_data)['content']
        digest_algorithm = cms_content['digest_algorithms'][0]['algorithm'].native
        attributes = cms_content['signer_infos'][0]['signed_attrs']
        digest_result = getattr(hashlib, digest_algorithm)(signed_data).digest()
        if attributes is not None and not isinstance(attributes, core.Void):
            cms_hash = None
            for attr in attributes:
                if attr['type'].native == 'message_digest':
                    cms_hash = attr['values'].native[0]
            cms_signed_data = attributes.dump()
            cms_signed_data = b'\x31' + cms_signed_data[1:]
        else:
            cms_hash = digest_result
            cms_signed_data = signed_data
        
        cms_hash_verfication = (digest_result == cms_hash)

        # Verify signature embedded in cms
        signature = cms_content['signer_infos'][0].native['signature']
        serial = cms_content['signer_infos'][0]['sid'].native['serial_number']
        public_key = None
        for certificate in cms_content['certificates']:
            if serial == certificate.native['tbs_certificate']['serial_number']:
                certificate = certificate.dump()
                certificate = pem.armor(u'CERTIFICATE', certificate)
                public_key = crypto.load_certificate(crypto.FILETYPE_PEM, certificate).get_pubkey().to_cryptography_key()
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

        return (cms_hash_verfication, cms_signature_verfication) 
    
    def load_certificate(self, certificate_data):
        self.store = crypto.X509Store()
        certificate = crypto.load_certificate(crypto.FILETYPE_PEM, certificate_data)
        self.store.add_cert(certificate)