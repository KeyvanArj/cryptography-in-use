from cryptography.hazmat.primitives.asymmetric import ec

class KeyExchange :

    def __init__(self):
        pass

    def generate_ecdh_aes256_shared_secret(self, server_ecc_private_key, client_ecc_public_key):
        shared_key = server_ecc_private_key.exchange(ec.ECDH(), client_ecc_public_key)
        return shared_key
