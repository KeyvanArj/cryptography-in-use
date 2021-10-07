import base64

class BinaryEncoder:

    @classmethod
    def to_hex_string(cls, data: bytearray) -> str:
        return data.hex()

    @classmethod
    def from_hex_string(cls, hex_string: str) -> bytearray:
        return bytearray.fromhex(hex_string)

    @classmethod
    def to_standard_base64(cls, data: bytearray) -> str:
        return base64.b64encode(data).decode()

    @classmethod
    def from_standard_base64(cls, base64_string: str) -> bytearray:
        return base64.b64decode(base64_string)

    @classmethod
    def to_urlsafe_base64(cls, data: bytearray) -> str:
        return base64.urlsafe_b64encode(data).decode()

    @classmethod
    def from_urlsafe_base64(cls, base64_string: str) -> bytearray:
        return base64.urlsafe_b64decode(base64_string)

    @classmethod
    def to_byte_array(cls, string: str) -> bytearray:
        return string.encode('utf-8')

    @classmethod
    def to_string(cls, data: bytearray) -> str:
        return data.decode('utf-8')

