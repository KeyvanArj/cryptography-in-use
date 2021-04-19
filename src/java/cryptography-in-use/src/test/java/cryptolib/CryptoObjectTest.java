package cryptolib;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Assertions;

public class CryptoObjectTest {
    
    private CryptoObject _cryptoObject;
    private String _pfxFilePath;
    private String _pfxFilePassword;

    @BeforeEach                                         
    public void setUp() {
        _cryptoObject = new CryptoObject();
        _pfxFilePath = "D:/workspace/cryptography-in-use/test-data/private/signer_bundle.pfx";
        _pfxFilePassword = "123456";
    }

    @Test
    @DisplayName("Load a pfx file")
    public void loadPrivateKeyTest()
    {
        int result = _cryptoObject.loadPrivateKey(_pfxFilePath, _pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);
    }
}
