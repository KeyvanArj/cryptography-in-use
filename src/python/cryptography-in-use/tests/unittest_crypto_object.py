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
    pass

    def test_sign_data(self):
        # Read binary stream of pdf file and certificate
        with open(self.test_data_path + '/bin/data_binary.bin', 'rb') as file_handler:
            binary_data = file_handler.read()
        
        cms_data = self.crypto_object.sign(self.rsa_keypair, binary_data)

        # print('cms_data-ContentInfo : ',  cms_data.__getitem__('content_type'))
        # print('cms_data : ',  base64.b64encode(cms_data))
        with open(self.test_data_path + '/bin/signed_data.der','wb+') as file_handler:
            file_handler.write(cms_data)

        call(["openssl", "cms", "-verify", "-in", self.test_data_path + "/bin/signed_data.der", "-inform", "DER", "-noverify"])

        pass    

if __name__ == '__main__':
    unittest.main()
