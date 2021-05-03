package cryptolib;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Assertions;

import java.io.File;
import java.io.IOException;

public class CryptoFileTest {

    private File _originalFile;
    private CryptoFile _cryptoFile;
    private String _testDataPath;
 
    @BeforeEach                                         
    public void setUp() throws IOException {
        _cryptoFile = new CryptoFile();
        _testDataPath = "D:/workspace/cryptography-in-use/test-data";
        _originalFile = new File(_testDataPath + "/pdf/original_document.pdf");
    }

    @Test
    @DisplayName("Encrypt a PDF file")
    public void encryptPdfFileTest() throws IOException
    {
        // Key is generated by the following command, it's a random 32 bytes array : 
        // $ openssl rand -base64 32
        // QNV2GQxfFWXwmZTWmoJrSxYNLmqTUxv9g5NeQpabc7E=
        // To convert it to hex string :
        // $ openssl enc -base64 -d <<< QNV2GQxfFWXwmZTWmoJrSxYNLmqTUxv9g5NeQpabc7E= | od -vt x1
        //   0000000 40 d5 76 19 0c 5f 15 65 f0 99 94 d6 9a 82 6b 4b
        //   0000020 16 0d 2e 6a 93 53 1b fd 83 93 5e 42 96 9b 73 b1
        String  keyBase64 = "QNV2GQxfFWXwmZTWmoJrSxYNLmqTUxv9g5NeQpabc7E=";

        // AES-256 has 128 bit blocks, so IV is generated by the following command, it's a random 16 bytes array :
        // $ openssl rand -base64 16
        // 0eQbwlW32F6wbv7ca2n8bg==
        // To convert it to hex string :
        // $ openssl enc -base64 -d <<< 0eQbwlW32F6wbv7ca2n8bg== | od -vt x1
        //   0000000 d1 e4 1b c2 55 b7 d8 5e b0 6e fe dc 6b 69 fc 6e
        String  ivBase64 = "0eQbwlW32F6wbv7ca2n8bg==";

        // Another way could be using pbkdf2 to derivate a Key and IV from a passkey
        // To encrypt the file, you can use the following command : 
        // $ openssl enc -aes-256-cbc -K 40d576190c5f1565f09994d69a826b4b160d2e6a93531bfd83935e42969b73b1 -iv d1e41bc255b7d85eb06efedc6b69fc6e -in test-data/pdf/plain_document.pdf -out test-data/pdf/openssl_ciphered_file.pdf
        // According to the OpenSSL document (https://www.openssl.org/docs/man1.1.1/man1/enc.html) :
        //      All the block ciphers normally use PKCS#5 padding
        File cipheredFile = new File(_testDataPath + "/pdf/ciphered_file.pdf");
        Boolean result = _cryptoFile.encrypt_aes_256_cbc_pkcs5(_originalFile, 
                                                                keyBase64,
                                                                ivBase64, 
                                                                cipheredFile);
        Assertions.assertTrue(result);

        // To check the encryption result : 
        // $ openssl enc -aes-256-cbc -d -K 40d576190c5f1565f09994d69a826b4b160d2e6a93531bfd83935e42969b73b1 -iv d1e41bc255b7d85eb06efedc6b69fc6e -in test-data/pdf/ciphered_file.pdf -out test-data/pdf/openssl_deciphered_file.pdf
    }
}
