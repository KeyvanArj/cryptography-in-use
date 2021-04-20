import unittest
import sys
sys.path.append("..")

from cryptolib.cryptopdf import CryptoPdf

class TestCryptoPdf(unittest.TestCase):

    def setUp(self):
        self.crypto_pdf = CryptoPdf()
        self.test_data_path = 'D:/workspace/cryptography-in-use/test-data'
        self.signed_pdf_file = open(self.test_data_path + '/pdf/signed_file.pdf', 'rb')
        self.certificate_file = open(self.test_data_path + '/certs/signer_cert.pem', 'rt')
        pass

    def test_verify_document(self):
        (cms_hash_verfication, cms_signature_verfication) = self.crypto_pdf.verify_document(self.signed_pdf_file, self.certificate_file)
        self.assertTrue(cms_hash_verfication)
        self.assertTrue(cms_signature_verfication)
        pass

if __name__ == '__main__':
    unittest.main()