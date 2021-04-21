import unittest
import sys
sys.path.append("..")

from cryptolib.cryptopdf import CryptoPdf

class TestCryptoPdf(unittest.TestCase):

    def setUp(self):
        self.crypto_pdf = CryptoPdf()
        self.test_data_path = 'D:/workspace/cryptography-in-use/test-data'
        pass

    def test_verify_document(self):
        # Read binary stream of pdf file and certificate
        with open(self.test_data_path + '/pdf/signed_by_zoom_id.pdf', 'rb') as file_handler:
            pdf_data = file_handler.read()
        with open(self.test_data_path + '/certs/signer_cert.pem', 'rt') as file_handler:
            certificate_data = file_handler.read()

        (cms_hash_verfication, cms_signature_verfication) = self.crypto_pdf.verify_document(pdf_data, certificate_data)
        self.assertTrue(cms_hash_verfication)
        self.assertTrue(cms_signature_verfication)
        pass

if __name__ == '__main__':
    unittest.main()