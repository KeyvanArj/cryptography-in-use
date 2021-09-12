import unittest
import sys
sys.path.append("..")

from cryptolib.ec_keypair import EcKeyPair
from cryptography.hazmat.primitives import serialization

class TestEcKeyPair(unittest.TestCase):
    
    def setUp(self):
        self.ec_keypair = EcKeyPair()       
        self.test_data_path = 'D:/workspace/cryptography-in-use/test-data' 
        self.ec_public_key_file_path = self.test_data_path + '/certs/client-ec-public-key.pem'
        self.ec_private_key_file_path = self.test_data_path + '/private/server-ec-private-key.pem'
    pass

    def test_ec_keypair_generation(self):
            self.ec_keypair.generate(self.ec_private_key_file_path, password=b'123456')
            pass

    def test_load_ec_public_key(self):
        self.ec_keypair.load_public_key(pem_file_path=self.ec_public_key_file_path)
        pass

    def test_load_ec_private_key(self):
        self.ec_keypair.load_private_key(pem_file_path=self.ec_private_key_file_path, password=b'123456')
        
        fileHandler = open(self.test_data_path + '/ecc/server_public.pem', 'wt')
        pem = self.ec_keypair.public_key.public_bytes(encoding=serialization.Encoding.PEM,
                                                      format=serialization.PublicFormat.SubjectPublicKeyInfo)
        fileHandler.write(pem.decode())
        fileHandler.close()
  
        pass

if __name__ == '__main__':
    unittest.main()
