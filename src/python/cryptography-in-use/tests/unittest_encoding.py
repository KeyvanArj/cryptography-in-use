
import unittest

encoders = __import__("encoders")

class TestEncoding(unittest.TestCase):

    def setUp(self):
        self.byte_list = [0xFF, 0xE2]
        pass

    def test_to_hex_string(self):
        hex_string = encoders.toHexString(self.byte_list)
        self.assertEqual(hex_string, 'FFE2')
        pass

    def test_from_hex_string(self):
        byte_array = encoders.fromHexString('FFE2')
        self.assertEqual(byte_array, bytes(self.byte_list))
        pass
   
    def test_to_base64_string(self):
        base64_string = encoders.toBase64String(self.byte_list)
        self.assertEqual(base64_string, '/+I=')
        pass

    def test_from_base64_string(self):
        byte_array = encoders.fromBase64String('/+I=')
        self.assertEqual(byte_array, bytes(self.byte_list))
        pass

if __name__ == '__main__':
    unittest.main()

