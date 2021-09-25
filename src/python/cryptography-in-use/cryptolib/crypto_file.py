from cryptolib.crypto_object import CryptoObject 

class CryptoFile(CryptoObject) :

    def __init__(self):
        pass

    def encrypt_aes_256_cbc_pkcs5(self,
                                  plain_file_path, 
                                  keyBase64,
                                  ivBase64):

        with open(plain_file_path, 'rb') as file_handler:
            plain_bytes = file_handler.read()

        return self.encrypt_aes256_cbc_pkcs5(plain_bytes, keyBase64, ivBase64);

        
