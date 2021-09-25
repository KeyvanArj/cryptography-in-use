import unittest
import sys
import base64

sys.path.append("..")

from cryptolib.crypto_file import CryptoFile

class TestCryptoFile(unittest.TestCase):
    
    def setUp(self):
        self.crypto_file = CryptoFile()
        self.test_data_path = 'D:/workspace/cryptography-in-use/test-data'

    def test_encrypt_aes256_cbc_pkcs5(self):
        keyBase64 = "rEScADQNDtMhG/O2fNFX77p2Ld6SfrcSZIyiKNrlOEc="
        ivBase64 = "0eQbwlW32F6wbv7ca2n8bg=="
        plain_file = self.test_data_path + '/pdf/original_document.pdf'
        # ciphered_file = self.test_data_path + '/pdf/ciphered_document.pdf'
        ciphered_bytes = self.crypto_file.encrypt_aes_256_cbc_pkcs5(plain_file, 
                                                                   keyBase64,
                                                                   ivBase64)

        # with open(ciphered_file, 'wb') as file_handler:
        #     file_handler.write(ciphered_bytes)
                                   
        print("ciphered data : ", base64.b64encode(ciphered_bytes));

        pass

if __name__ == '__main__':
    unittest.main()       