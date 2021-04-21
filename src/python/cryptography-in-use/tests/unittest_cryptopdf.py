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
        with open(self.test_data_path + '/pdf/signed_document.pdf', 'rb') as file_handler:
            pdf_data = file_handler.read()
        
        # Verify Signature, hash of data and signing time embedded in cms
        (cms_hash_verfication, 
         cms_signature_verfication, 
         signing_time_verification, 
         cms_certificates) = self.crypto_pdf.verify_document(pdf_data)
        
        self.assertTrue(cms_hash_verfication)
        self.assertTrue(cms_signature_verfication)
        self.assertTrue(signing_time_verification)
            
        # Verify certificates embedded in cms
        with open(self.test_data_path + '/certs/signer_cert.pem', 'rt') as file_handler:
            signer_certificate_data = file_handler.read()
        with open(self.test_data_path + '/certs/cacert.pem', 'rt') as file_handler:
            ca_certificate_data = file_handler.read()

        for cms_certificate in cms_certificates : 
            # save for debug if needed
            with open(self.test_data_path + '/certs/cms_cert.crt', 'wt') as file_handler:
                file_handler.write(cms_certificate)
            # You can see the content of cms certificate by the following command : 
            # $ openssl x509 -in certs/cms_cert.crt -text -noout 

        pass

if __name__ == '__main__':
    unittest.main()