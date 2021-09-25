import hashlib
import io
from asn1crypto import core
from cryptolib.crypto_object import CryptoObject 
from PyPDF2 import pdf, generic

class CryptoPdf(CryptoObject) : 

    def __init__(self):
        pass

    def sign_document(self, pdf_data, signature_dictionary, keypair):
        
        digest_algoirthm = "sha256"

        start_data = len(pdf_data)

        fileStream = io.BytesIO(pdf_data)

        # construct original pdf structure 
        original_pdf = pdf.PdfFileReader(fileStream)

        # digest method must remain unchanged from prevoius signatures
        trailer = original_pdf.trailer
        for k in ("/Root", "/Perms", "/DocMDP", "/Reference"):
            if k in trailer:
                trailer = trailer[k]
                if isinstance(trailer, generic.ArrayObject):
                    trailer = trailer[0]
                trailer = trailer.getObject()
            else:
                trailer = None
                break
        if trailer is not None:
            digest_algoirthm = trailer["/DigestMethod"][1:].lower()

        message_digest = getattr(hashlib, digest_algoirthm)().digest()
        contents = self.sign(keypair, message_digest)
        zeros = contents.hex().encode("utf-8")
    pass

    def verify_document(self, pdf_data):

        start_index = 0
        cms_hash_verfication_result = True
        cms_signature_verfication_result = True
        signing_time_verification_result = True
        cms_certificates_list = []

        while (start_index != -1):
            # Extract the content and signed data of pdf
            (cms_data, signed_data, stop_index) = self.extract_signature_data(pdf_data, start_index)

            if(stop_index == -1):
                break
            start_index = stop_index
            
            # verify the hash of signed data by which is included in cms_data
            # and the signature emdedded in cms_data 
            (   cms_hash_verfication, 
                cms_signature_verfication, 
                signing_time_verification, 
                cms_certificates )  = self.verify_cms(cms_data, signed_data)
            
            cms_hash_verfication_result &= cms_hash_verfication
            cms_signature_verfication_result &= cms_signature_verfication
            signing_time_verification_result &= signing_time_verification

            for certificate in cms_certificates:
                cms_certificates_list.append(certificate)

        return (cms_hash_verfication_result, 
                cms_signature_verfication_result, 
                signing_time_verification_result, 
                cms_certificates_list)

    def extract_pdf_content(self, pdf_data):
        
        pass

    def extract_signature_data(self, pdf_data, start_index):
        
        index = pdf_data.find(b"/ByteRange", start_index)
        start = pdf_data.find(b"[", index)
        stop = pdf_data.find(b"]", start)

        if ((index == -1) or (start == -1) or (stop == -1)):
            return (core.Null, core.Null, -1)
        
        br = [int(i, 10) for i in pdf_data[start + 1 : stop].split()]
        
        cms_data = pdf_data[br[0] + br[1] + 1 : br[2] - 1]
        cms_bytes = bytes.fromhex(cms_data.decode("utf8"))
        
        data1 = pdf_data[br[0] : br[0] + br[1]]
        data2 = pdf_data[br[2] : br[2] + br[3]]

        signed_data = data1 + data2

        return (cms_bytes, signed_data, stop)