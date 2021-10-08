package cryptolib;

import org.junit.jupiter.api.Test;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Assertions;

import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;

import org.bouncycastle.util.encoders.Base64;
import org.bouncycastle.util.encoders.Hex;
import java.nio.charset.StandardCharsets;

public class CryptoObjectTest {
    
    private CryptoObject _cryptoObject;
    private String _pfxFilePath;
    private String _pfxFilePassword;

    @BeforeEach                                         
    public void setUp() {
        _cryptoObject = new CryptoObject();
        _pfxFilePath = TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/private/signer_bundle.pfx";
        _pfxFilePassword = "123456";
    }

    @Test
    @DisplayName("Load a pfx file")
    public void loadPrivateKeyTest()
    {
        int result = _cryptoObject.loadPrivateKey(_pfxFilePath, _pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);
    }

    @Test
    @DisplayName("Encrypt message")
    public void encryptMessageTest() {
        String  keyBase64 = "rEScADQNDtMhG/O2fNFX77p2Ld6SfrcSZIyiKNrlOEc=";
        String  ivBase64 = "0eQbwlW32F6wbv7ca2n8bg==";
        byte[] plainData = "Hi, Mojtaba".getBytes(StandardCharsets.UTF_8);
        byte[] cipheredData = _cryptoObject.encrypt_aes_256_cbc_pkcs5(plainData, 
                                                                keyBase64,
                                                                ivBase64);
        System.out.println("cipheredData : " + Base64.toBase64String(cipheredData));
        Assertions.assertNotNull(cipheredData);
    }

    @Test
    @DisplayName("Key Exchange")
    public void cmsSignTest() throws NoSuchAlgorithmException, InvalidKeyException, SignatureException
    {
        int result = _cryptoObject.loadPrivateKey(_pfxFilePath, _pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        String mobileNo = "09123330890";
        String udid = "11671fe4-9652-91fb-c9d9";
        String data = mobileNo + ":" + udid;
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] encodedHash = digest.digest(data.getBytes(StandardCharsets.UTF_8)); 
        String sha256hex = new String(Hex.encode(encodedHash));
        String cms = _cryptoObject.cmsSignText(sha256hex);
        System.out.println("cms : " +  cms);
    }
}
