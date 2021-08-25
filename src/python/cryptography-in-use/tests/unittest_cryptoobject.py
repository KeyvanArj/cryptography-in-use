import unittest
import sys
import base64
from subprocess import call

sys.path.append("..")

from cryptolib.cryptoobject import CryptoObject

class TestCryptoObject(unittest.TestCase):

    def setUp(self):
        self.crypto_object = CryptoObject()
        self.test_data_path = '/Users/mojtabamirzadeh/Workspace/cms-codec/cryptography-in-use/test-data'
        self.pfx_file_path = self.test_data_path + '/private/signer_bundle.pfx'
        self.pfx_file_password = b'123456'
        self.crypto_object.load_private_key(self.pfx_file_path, self.pfx_file_password)
        pass

    def test_sign_data(self):
        # Read binary stream of pdf file and certificate
        with open(self.test_data_path + '/bin/data_binary.bin', 'rb') as file_handler:
            binary_data = file_handler.read()
        
        cms_data = self.crypto_object.sign(binary_data)

        # print('cms_data-ContentInfo : ',  cms_data.__getitem__('content_type'))
        # print('cms_data : ',  cms_data.hex())
        with open(self.test_data_path + '/bin/signed_data.der','wb+') as file_handler:
            file_handler.write(cms_data)

        call(["openssl", "cms", "-verify", "-in", self.test_data_path + "/bin/signed_data.der", "-inform", "DER", "-noverify"])

        pass    

    def test_verify_cms(self):
        
        # signature = 'MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwGggCSABAJOQQAAAAAAAKCAMIICyzCCAbOgAwIBAgIBCjANBgkqhkiG9w0BAQsFADApMRowGAYDVQQKExFBbmRyb2lkIEF1dGhvcml0eTELMAkGA1UEAxMCY24wHhcNMjEwODIxMTE0MTA5WhcNMjEwODIxMTI0MTA5WjApMRowGAYDVQQKExFBbmRyb2lkIEF1dGhvcml0eTELMAkGA1UEAxMCY24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDnN+5ttcZkLk5TTKVIzrVpFIpze9Gm8sdt1LvPuKQLXX3wIct8g3qMMNlFJa/eS4T3hd6Knp4ivotm8LlGKmxGMccWFoXvuCPqQNBRJboxTAK2kW6FsCQmEpXmk/0q+2dU6oQPfjuYw1SS1xnuCo+m94Ylzj0M4iVaTteloNLOEUUctacvAT3pbct98Y7asRwqF53iI0uOdbLOZrS+QcFIAi1dQcKJ9tOxRAHeeAUCaxCFnRh8ogxxzsFA7lHCCzdFspjhC+RtKcn4pcMSywXe96oadZN6m1Srd2oDjaKFGIM8y2eZ0p4vTp6BHw7z00CoKe+NomVatdcxAi1wVxoLAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAHFUkvuyPTWP+mW7lQjGv0PxH0f4qRmN3MV+u2qf2WUY4/PZwNM420p5xj+WciW90R5fSuPUff7DkJ1WYgfJyZmqrRbULUeS5ICIzQ9Q3nsYRp3SuXbx+r4e05Yiw5PL0ZJi/uSScrDTsQQF1twQCHsm8XHFLbKMwB6ItH402lKusZEgWZkBdlDwdWEEVOKo2o6PK148UTFAgH4WuCGfacua9UZBeAgdJ6/m1RBJqOnlfXcZSf0YHbcv/whM/Kqs/G8UMNwIalxMyhrTuPV01VxjFm2ln6FglPVeYsbzYQhUZKbs/nFrE0ld2IcHQ0CZSsrPNEK2uP/UAOZgUAvd194AADGCAfQwggHwAgEBMC4wKTEaMBgGA1UEChMRQW5kcm9pZCBBdXRob3JpdHkxCzAJBgNVBAMTAmNuAgEKMA0GCWCGSAFlAwQCAQUAoIGYMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgyMTExNDEyN1owLQYJKoZIhvcNAQk0MSAwHjANBglghkgBZQMEAgEFAKENBgkqhkiG9w0BAQsFADAvBgkqhkiG9w0BCQQxIgQgIO8PDI0O6ph3JBLOqbO5JhLj5Ty15ZFStXAxZfVuilMwDQYJKoZIhvcNAQELBQAEggEAZIR4Sca6pO0GBaUvsii/iKg1ueyMq2s7VLRuTYqSV6Ffu1FDm23Edl3v9q1ebgqQEbUfF+UKZMqjkSddlUzzyoyCf3efaR1QXAHdKfDeZwnNqncZCRJwbRsjaC7NqfmqjeU9lLcOFCso/zoLZyAa3UYIvMweN4e8K6nGKQC/AX95ijtTk2KiFNKo2ZfC2a7JGJS0g/99i1JLJ5FHSLhtqCJr9pKAShCtj3x7uIAfYpYX4WHF0A+GUoJbLvjeI4DWbyYHZBfOu+hvwzJzFut7REUJuJaqAfl8HfbU9bNzMrCK+377+GQavUHVYhl2uwYFAqtI1Vznr2B3+6FRCowDHQAAAAAAAA=='
        # print(base64.b64decode(signature).hex())
        
        signed_data = b'09128894558:C463213C-3332-4F31-BE5B-86EB51961A93' # bytes.fromhex('4e41')
        print('signed data : ', signed_data.decode())

        cms_data = base64.b64decode('MIIFSQYJKoZIhvcNAQcCoIIFOjCCBTYCAQMxDTALBglghkgBZQMEAgEwPwYJKoZIhvcNAQcBoDIEMDA5MTI4ODk0NTU4OkM0NjMyMTNDLTMzMzItNEYzMS1CRTVCLTg2RUI1MTk2MUE5M6CCAxQwggMQMIIB+qADAgECAggT4n0/xKX71TALBgkqhkiG9w0BAQswgakxCzAJBgNVBAYTAklSMQ8wDQYDVQQIDAZUZWhyYW4xGTAXBgNVBAoMEE5vbi1Hb3Zlcm5tZW50YWwxEDAOBgNVBAsMB1RlY3Zlc3QxJDAiBgNVBAsMG1NtYXJ0IFRydXN0IEludGVybWVkaWF0ZSBDQTE2MDQGA1UEAwwtU21hcnQgdHJ1c3QgcHJpdmF0ZSBpbnRlcm1lZGlhdGUgYnJvbnplIENBLUczMB4XDTIxMDgwMzE0MTAxN1oXDTIzMDgwMzE0MTAxN1owgaAxCzAJBgNVBAYTAklSMRUwEwYDVQQKDAxVbmFmZmlsaWF0ZWQxFzAVBgNVBAQMDtmF2YrYsdiy2KfYr9mHMRkwFwYDVQQqDBDYs9mK2K/Zhdis2KrYqNmKMRMwEQYDVQQFDAowMDEyMzAwMzA2MRkwFwYDVQQDDBBtb2ppIG1pZXIgW3NpZ25dMRYwFAYJKoZIhvcNAQkBDAdtQG0uY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAElMTNv/EwpspWMZFMVSjRu+P4cpJ+gBoVb841B5+JfQl889wyTmCPHE3dBXDiDvQbhOSRItFHF7ZFV40cBZH2tqMSMBAwDgYDVR0PAQH/BAQDAgbAMAsGCSqGSIb3DQEBCwOCAQEALM6W4h8c5txe0UaFzOKL9FA5M86K7DQ5qAukL+0CN+Jwk2VwwVJ8fSSDQMtN088Y117XnTZjDUac1PdMGKZXq9M+F6Pv+kFpZIqHdIgpHfx2JN1j7KaKmEg4lRg3PDdbTK2FEsnmfcRtoNPIvsIBhbIFYPCJj4iRJUXBMd2dc+cPD8qcLIGuuf+v7v8JUl0pwTVzNgo09K7QwzVio6+lyJO8UjOGhbi2lE33kj7wtXs8t4c2vkcOez03Q6cHZaAAJMx/zfLorGHrC440x0VUkZF4ktybYdDu+49S/bkUtXlMvI9nRKnaNIxnaSaYEdThhREGCwnC2KFqKakG+zdddjGCAccwggHDAgEBMIHEMIG3MQswCQYDVQQGEwJJUjEPMA0GA1UECAwGVGVocmFuMQ8wDQYDVQQHDAZUZWhyYW4xEDAOBgNVBAoMB1RlY3Zlc3QxJDAiBgNVBAsMG1NtYXJ0IFRydXN0IEludGVybWVkaWF0ZSBDQTE2MDQGA1UEAwwtU21hcnQgdHJ1c3QgcHJpdmF0ZSBpbnRlcm1lZGlhdGUgYnJvbnplIENBLUczMRYwFAYJKoZIhvcNAQkBFgdtQG0uY29tAggT4n0/xKX71TALBglghkgBZQMEAgGggZMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEwOTE4MDUxNDM2WjAoBgkqhkiG9w0BCTQxGzAZMAsGCWCGSAFlAwQCAaEKBggqhkjOPQQDAjAvBgkqhkiG9w0BCQQxIgQgZlAA4NcgPkrvE7IZUNpzJ1EtPyVWtWkYAqQQeuBQWTwwCgYIKoZIzj0EAwIESDBGAiEA7R3BFkpQICVYAstA+9wMu7UuA8h1fI1cUOW81xN/K0ICIQCI0zQ224iPpsHm7EsnlnE3+4+tljgDXmC8vae2wx83UQ==')
        self.crypto_object.verify_cms(cms_data=cms_data, signed_data=signed_data)
        
        pass

if __name__ == '__main__':
    unittest.main()
