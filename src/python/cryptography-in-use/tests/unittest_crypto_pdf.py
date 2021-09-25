import datetime
import unittest
import sys
sys.path.append("..")

from cryptolib.crypto_pdf import CryptoPdf
from cryptolib.rsa_keypair import RsaKeyPair

class TestCryptoPdf(unittest.TestCase):

    def setUp(self):
        self.crypto_pdf = CryptoPdf()
        self.test_data_path = 'D:/workspace/cryptography-in-use/test-data'
        self.rsa_keypair = RsaKeyPair()
        self.pfx_file_path = self.test_data_path + '/private/signer_bundle.pfx'
        self.pfx_file_password = b'123456'
        self.rsa_keypair.load(self.pfx_file_path, self.pfx_file_password)
        pass

    def test_sign_document(self):
        date = datetime.datetime.utcnow() - datetime.timedelta(hours=12)
        date = date.strftime("D:%Y%m%d%H%M%S+00'00'")
        signature_dictionary = {
        "aligned":0,
        "sigbutton": True,
        "sigfield": "Signature1",
        "auto_sigfield": True,
        "sigandcertify": True,
        "signingdate": date,
        "reason": "sign document",
        }
        # Read binary stream of pdf file and certificate
        with open(self.test_data_path + '/pdf/original_document.pdf', 'rb') as file_handler:
            pdf_data = file_handler.read()
    
        signed_pdf = self.crypto_pdf.sign_document(pdf_data, signature_dictionary, self.rsa_keypair)
        self.assertIsNotNone(signed_pdf)

        with open(self.test_data_path + '/pdf/signed_document.pdf', 'wb') as file_handler:
            file_handler.write(signed_pdf)
    
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

        certficate_number = 0
        for cms_certificate in cms_certificates : 
            certficate_number += 1
            # save for debug if needed
            with open(self.test_data_path + '/certs/cms_cert_' + str(certficate_number) + '.crt', 'wt') as file_handler:
                file_handler.write(cms_certificate)
            # You can see the content of cms certificate by the following command : 
            # $ openssl x509 -in certs/cms_cert.crt -text -noout 
        pass

if __name__ == '__main__':
    unittest.main()