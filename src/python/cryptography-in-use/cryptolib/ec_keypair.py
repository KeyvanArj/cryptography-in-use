
from cryptography.hazmat.primitives.serialization import load_pem_public_key, load_pem_private_key, Encoding, PrivateFormat, BestAvailableEncryption
from cryptography.hazmat.primitives.asymmetric import ec
from cryptolib.keypair import KeyPair

class EcKeyPair(KeyPair) :

    def __init(self):
        pass

    def load_public_key(self, pem_file_path):
        fileHandler = open(pem_file_path,'rt')
        pem_data = fileHandler.read()
        self._public_key = load_pem_public_key(pem_data.encode())
        fileHandler.close()
        pass

    def generate(self, pem_file_path=None, password=None):
        self._private_key = ec.generate_private_key(ec.SECP256R1())
        self._public_key = self._private_key.public_key()
        if(pem_file_path != None) : 
            fileHandler = open(pem_file_path, 'wt')
            fileHandler.write(self._private_key.private_bytes(encoding=Encoding.PEM,
                                                              format=PrivateFormat.PKCS8,
                                                              encryption_algorithm=BestAvailableEncryption(password)).decode())
            fileHandler.close()
        pass

    def load_private_key(self, pem_file_path, password):
        fileHandler = open(pem_file_path,'rt')
        pem_data = fileHandler.read()
        self._private_key = load_pem_private_key(pem_data.encode(), password=password)
        fileHandler.close()
        self._public_key = self._private_key.public_key()
        pass