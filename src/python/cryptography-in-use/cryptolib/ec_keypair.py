
from cryptography.hazmat.primitives.serialization import load_pem_public_key, load_pem_private_key, Encoding, PrivateFormat, BestAvailableEncryption
from cryptography.hazmat.primitives.asymmetric import ec
from cryptolib.keypair import KeyPair

class EcKeyPair(KeyPair) :

    def __init__(self):
        self._public_key = None
        self._private_key = None

    def load_public_key(self, pem_file_path):
        file_handler = open(pem_file_path,'rt')
        pem_data = file_handler.read()
        self._public_key = load_pem_public_key(pem_data.encode())
        file_handler.close()

    def generate(self, pem_file_path=None, password=None):
        self._private_key = ec.generate_private_key(ec.SECP256R1())
        self._public_key = self._private_key.public_key()
        if(pem_file_path != None) : 
            file_handler = open(pem_file_path, 'wt')
            file_handler.write(self._private_key.private_bytes(encoding=Encoding.PEM,
                                                              format=PrivateFormat.PKCS8,
                                                              encryption_algorithm=BestAvailableEncryption(password)).decode())
            file_handler.close()

    def load_private_key(self, pem_file_path, password):
        file_handler = open(pem_file_path,'rt')
        pem_data = file_handler.read()
        self._private_key = load_pem_private_key(pem_data.encode(), password=password)
        file_handler.close()
        self._public_key = self._private_key.public_key()