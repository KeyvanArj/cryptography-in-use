import unittest
import sys
sys.path.append("..")

from cryptolib.ec_keypair import EcKeyPair
from cryptolib.keyexchange import KeyExchange
from cryptography.hazmat.primitives import serialization

class TestKeyExchange(unittest.TestCase):
    
    def setUp(self):
        self.server_ec_keypair = EcKeyPair()
        self.client_ec_keypair = EcKeyPair()       
        self.test_data_path = 'D:/workspace/cryptography-in-use/test-data' 
        self.client_ec_public_key_file_path = self.test_data_path + '/certs/client-ec-public-key.pem'
        self.client_ec_keypair.load_public_key(pem_file_path=self.client_ec_public_key_file_path)
        self.server_ec_private_key_file_path = self.test_data_path + '/private/server-ec-private-key.pem'
        self.server_ec_keypair.load_private_key(pem_file_path=self.server_ec_private_key_file_path, password=b'123456')
        self.keyexchange = KeyExchange()
    pass

    def test_generate_ecdh_aes256_key(self):
            pem = self.server_ec_keypair.public_key.public_bytes(encoding=serialization.Encoding.PEM,
                                                                 format=serialization.PublicFormat.SubjectPublicKeyInfo)
            print("Server Public Key PEM : ", pem)
            
            pem = self.client_ec_keypair.public_key.public_bytes(encoding=serialization.Encoding.PEM,
                                                      format=serialization.PublicFormat.SubjectPublicKeyInfo)
            print("Client Public Key PEM : ", pem)
            
            shared_secret = self.keyexchange.generate_ecdh_aes256_shared_secret(self.server_ec_keypair.private_key, 
                                                                                self.client_ec_keypair.public_key)
            self.assertEqual(shared_secret.hex().upper(), '1f7040878e957efcf340a07082ff9059743ebfb7213b06726a50032d64619c78'.upper())#'9241E08C0C8B7620BB62FE6A91610E8BB013FB6B3D946CE3B8170B871625D033')
            pass

if __name__ == '__main__':
    unittest.main()
