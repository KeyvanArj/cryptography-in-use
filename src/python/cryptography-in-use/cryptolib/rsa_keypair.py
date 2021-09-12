
from cryptography.hazmat.primitives.serialization import pkcs12, Encoding
from asn1crypto import x509, pem
from cryptolib.keypair import KeyPair

class RsaKeyPair(KeyPair):

    def __init__(self):
        pass

    def load(self, pfx_file_path, pfx_file_password):
   
        # open it, using password
        with open(pfx_file_path, "rb") as key_file:
            (self._private_key,
             certificate,
             certificates) = pkcs12.load_key_and_certificates(key_file.read(), password=pfx_file_password)
        
        _, _, pem_bytes = pem.unarmor(certificate.public_bytes(Encoding.PEM))
        self._certificate = x509.Certificate.load(pem_bytes)
        self._public_key = self._private_key.public_key()
        
        pass


