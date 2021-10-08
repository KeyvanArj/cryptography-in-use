package main.java.cryptolib;

import org.bouncycastle.util.encoders.Base64;
import org.bouncycastle.util.encoders.Hex;
import java.nio.charset.StandardCharsets;

public class BinaryEncoder {
    
    public static final String EMPTY_STRING = new StringBuffer(0).toString();
    public static final byte[] EMPTY_BYTES = new byte[0];

    private BinaryEncoder () {

    }
    
    public static byte[] toByteArray(String inString) {
        if(inString == null)
            return EMPTY_BYTES;
        if(inString.length() == 0)
            return EMPTY_BYTES;    
        return inString.getBytes(StandardCharsets.UTF_8);
    }
    
    public static String toString(byte[] data) {
        if(data == null)
            return EMPTY_STRING;
        if(data.length == 0)
            return EMPTY_STRING;    
        return new String(data, StandardCharsets.UTF_8);
    }

    public static String toHexString(byte[] data) {
        if(data == null)
            return EMPTY_STRING;
        if(data.length == 0)
            return EMPTY_STRING;    
        return new String(Hex.encode(data));
    }

    public static byte[] fromHexString(String hexString) {
        if(hexString == null)
            return EMPTY_BYTES;
        if(hexString.length() == 0)
            return EMPTY_BYTES;    
        return Hex.decode(hexString);
    }

    public static String toStandardBase64(byte[] data) {
        if(data == null)
            return EMPTY_STRING;
        if(data.length == 0)
            return EMPTY_STRING;    
        return new String(java.util.Base64.getEncoder().encode(data));
    }

    public static byte[] fromStandardBase64(String base64String) {
        if(base64String == null)
            return EMPTY_BYTES;
        if(base64String.length() == 0)
            return EMPTY_BYTES;    
        return java.util.Base64.getDecoder().decode(base64String);
    }

    public static String toUrlSafeBase64(byte[] data) {
        if(data == null)
            return EMPTY_STRING;
        if(data.length == 0)
            return EMPTY_STRING;    
        return new String(java.util.Base64.getUrlEncoder().encode(data));
    }

    public static byte[] fromUrlSafeBase64(String base64String) {
        if(base64String == null)
            return EMPTY_BYTES;
        if(base64String.length() == 0)
            return EMPTY_BYTES;    
        return java.util.Base64.getUrlDecoder().decode(base64String);
    }
}
