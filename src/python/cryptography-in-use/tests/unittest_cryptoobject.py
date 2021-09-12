import unittest
import sys
import base64
from subprocess import call
from cryptography.hazmat.primitives import serialization
sys.path.append("..")

from cryptolib.crypto_object import CryptoObject
from cryptolib.rsa_keypair import RsaKeyPair

class TestCryptoObject(unittest.TestCase):

    def setUp(self):
        self.crypto_object = CryptoObject()
        self.test_data_path = 'D:/workspace/cryptography-in-use/test-data'
        
        self.rsa_keypair = RsaKeyPair()
        self.pfx_file_path = self.test_data_path + '/private/signer_bundle.pfx'
        self.pfx_file_password = b'123456'
        self.rsa_keypair.load(self.pfx_file_path, self.pfx_file_password)
        
        self.ecc_public_key_file_path = self.test_data_path + '/certs/client-ec-public-key.pem'
        self.ecc_private_key_file_path = self.test_data_path + '/private/server-ec-private-key.pem'
    pass

    # def test_ecc_private_key_generation(self):
    #     self.crypto_object.generate_server_ecc_private_key(self.ecc_private_key_file_path, password=b'123456')
    #     pass

    def test_load_ecc_public_key(self):
        self.crypto_object.load_client_ecc_public_key(pem_file_path=self.ecc_public_key_file_path)
        pass

    def test_load_ecc_private_key(self):
        self.crypto_object.load_server_ecc_private_key(pem_file_path=self.ecc_private_key_file_path, password=None)#b'123456')
        
        fileHandler = open(self.test_data_path + '/ecc/server_public.pem', 'wt')
        pem = self.crypto_object.server_ecc_private_key.public_key().public_bytes(encoding=serialization.Encoding.PEM,
                                                                                  format=serialization.PublicFormat.SubjectPublicKeyInfo)
        fileHandler.write(pem.decode())
        fileHandler.close()
  
        pass

    def test_generate_ecdh_aes256_key(self):
        self.crypto_object.load_server_ecc_private_key(pem_file_path=self.ecc_private_key_file_path, password=None)#b'123456')
        pem = self.crypto_object.server_ecc_private_key.public_key().public_bytes(encoding=serialization.Encoding.PEM,
                                                                                 format=serialization.PublicFormat.SubjectPublicKeyInfo)
        # print("Server Public Key PEM : ", pem)
        
        self.crypto_object.load_client_ecc_public_key(pem_file_path=self.ecc_public_key_file_path)
        pem = self.crypto_object.client_ecc_public_key.public_bytes(encoding=serialization.Encoding.PEM,
                                                                                 format=serialization.PublicFormat.SubjectPublicKeyInfo)
        # print("Client Public Key PEM : ", pem)
        
        shared_secret = self.crypto_object.generate_ecdh_aes256_shared_secret()
        self.assertEqual(shared_secret.hex().upper(), '732fcb4c7e77b60dae97b97d46af4610b41c6b274f20d0b3dea207f553a5029c'.upper())#'9241E08C0C8B7620BB62FE6A91610E8BB013FB6B3D946CE3B8170B871625D033')
        pass

    def test_sign_data(self):
        # Read binary stream of pdf file and certificate
        with open(self.test_data_path + '/bin/data_binary.bin', 'rb') as file_handler:
            binary_data = file_handler.read()
        
        cms_data = self.crypto_object.sign(binary_data)

        # print('cms_data-ContentInfo : ',  cms_data.__getitem__('content_type'))
        # print('cms_data : ',  base64.b64encode(cms_data))
        with open(self.test_data_path + '/bin/signed_data.der','wb+') as file_handler:
            file_handler.write(cms_data)

        call(["openssl", "cms", "-verify", "-in", self.test_data_path + "/bin/signed_data.der", "-inform", "DER", "-noverify"])

        pass    

if __name__ == '__main__':
    unittest.main()
