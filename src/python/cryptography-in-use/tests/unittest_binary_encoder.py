
import unittest
import sys
sys.path.append("..")

from cryptolib.binary_encoder import BinaryEncoder

class TestBinaryEncoding(unittest.TestCase):

    def setUp(self):
        self.data = bytearray([0xFF, 0xE2])

    def test_to_byte_array(self):
        byte_array = BinaryEncoder.to_byte_array(string='پاسارگاد')
        self.assertEqual(byte_array, bytearray([0xD9, 0xBE, 0xD8, 0xA7, 0xD8, 0xB3, 0xD8, 0xA7, 0xD8, 0xB1, 0xDA, 0xAF, 0xD8, 0xA7, 0xD8, 0xAF]))
    
    def test_to_string(self):
        string = BinaryEncoder.to_string(data=bytearray([0xD9, 0xBE, 0xD8, 0xA7, 0xD8, 0xB3, 0xD8, 0xA7, 0xD8, 0xB1, 0xDA, 0xAF, 0xD8, 0xA7, 0xD8, 0xAF]))
        self.assertEqual(string, 'پاسارگاد')

    def test_to_hex_string(self):
        hex_string = BinaryEncoder.to_hex_string(data=self.data)
        self.assertEqual(hex_string.upper(), 'FFE2')
        
    def test_from_hex_string(self):
        byte_array = BinaryEncoder.from_hex_string(hex_string='FFE2')
        self.assertEqual(byte_array, bytes(self.data))
        
    def test_to_standard_base64_string(self):
        base64_string = BinaryEncoder.to_standard_base64(data=self.data)
        self.assertEqual(base64_string, '/+I=')
        
    def test_from_standard_base64_string(self):
        byte_array = BinaryEncoder.from_standard_base64(base64_string='/+I=')
        self.assertEqual(byte_array, bytes(self.data))
    
    def test_to_urlsafe_base64_string(self):
        base64_string = BinaryEncoder.to_urlsafe_base64(data=self.data)
        self.assertEqual(base64_string, '_-I=')
        
    def test_from_urlsafe_base64_string(self):
        byte_array = BinaryEncoder.from_urlsafe_base64(base64_string='_-I=')
        self.assertEqual(byte_array, bytes(self.data))

if __name__ == '__main__':
    unittest.main()

