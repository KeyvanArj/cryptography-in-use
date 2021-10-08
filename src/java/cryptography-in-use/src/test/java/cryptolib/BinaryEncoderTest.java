package cryptolib;

import org.junit.jupiter.api.Test;

import main.java.cryptolib.BinaryEncoder;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Assertions;

public class BinaryEncoderTest {
    
    @Test
    @DisplayName("Encode a binary data to string")
    public void toStringTest() {
        byte[] byteArray = new byte[] {(byte)0xD9, (byte)0xBE, (byte)0xD8, (byte)0xA7, (byte)0xD8, (byte)0xB3, (byte)0xD8, (byte)0xA7, (byte)0xD8, (byte)0xB1, (byte)0xDA, (byte)0xAF, (byte)0xD8, (byte)0xA7, (byte)0xD8, (byte)0xAF};
        String string = BinaryEncoder.toString(byteArray);
        Assertions.assertEquals(string, "پاسارگاد");
    }

    @Test
    @DisplayName("Decode a binary data from string")
    public void toByteArrayTest() {
        byte[] expectedByteArray = new byte[] {(byte)0xD9, (byte)0xBE, (byte)0xD8, (byte)0xA7, (byte)0xD8, (byte)0xB3, (byte)0xD8, (byte)0xA7, (byte)0xD8, (byte)0xB1, (byte)0xDA, (byte)0xAF, (byte)0xD8, (byte)0xA7, (byte)0xD8, (byte)0xAF};
        byte[] byteArray = BinaryEncoder.toByteArray("پاسارگاد");
        Assertions.assertArrayEquals(byteArray, expectedByteArray);
    }

    @Test
    @DisplayName("Encode a binary data to hex string")
    public void toHexStringTest() {
        byte[] byteArray = new byte[] {(byte)0xFF, (byte)0xE2};
        String string = BinaryEncoder.toHexString(byteArray);
        Assertions.assertEquals(string.toUpperCase(), "FFE2");
    }

    @Test
    @DisplayName("Decode a binary data from hex string")
    public void fromHexStringTest() {
        byte[] expectedByteArray = new byte[] {(byte)0xFF, (byte)0xE2};
        byte[] byteArray = BinaryEncoder.fromHexString("FFE2");
        Assertions.assertArrayEquals(expectedByteArray, byteArray);
    }

    @Test
    @DisplayName("Encode a binary data to standard base64 string")
    public void toStandardBase64Test() {
        byte[] byteArray = new byte[] {(byte)0xFF, (byte)0xE2};
        String string = BinaryEncoder.toStandardBase64(byteArray);
        Assertions.assertEquals(string, "/+I=");
    }

    @Test
    @DisplayName("Decode a binary data from standard base64 string")
    public void fromStandardBase64Test() {
        byte[] expectedByteArray = new byte[] {(byte)0xFF, (byte)0xE2};
        byte[] byteArray = BinaryEncoder.fromStandardBase64("/+I=");
        Assertions.assertArrayEquals(expectedByteArray, byteArray);
    }

    @Test
    @DisplayName("Encode a binary data to url-safe base64 string")
    public void toUrlSafeBase64Test() {
        byte[] byteArray = new byte[] {(byte)0xFF, (byte)0xE2};
        String string = BinaryEncoder.toUrlSafeBase64(byteArray);
        Assertions.assertEquals(string, "_-I=");
    }

    @Test
    @DisplayName("Decode a binary data from url-safe base64 string")
    public void fromUrlSafeBase64Test() {
        byte[] expectedByteArray = new byte[] {(byte)0xFF, (byte)0xE2};
        byte[] byteArray = BinaryEncoder.fromUrlSafeBase64("_-I=");
        Assertions.assertArrayEquals(expectedByteArray, byteArray);
    }
}
