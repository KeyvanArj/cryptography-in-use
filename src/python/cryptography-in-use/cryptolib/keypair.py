from asn1crypto import x509

class KeyPair:

    _private_key = None
    _public_key = None
    _certificate = x509.Certificate()

    def __init__(self):
        pass

    @property
    def private_key(self):
        return self._private_key

    @property
    def certificate(self):
        return self._certificate

    @property
    def public_key(self):
        return self._public_key
    