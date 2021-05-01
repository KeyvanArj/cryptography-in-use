package cryptolib;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Assertions;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;

/**
 * Unit test for CryptoPdf library.
 */
public class CryptoPdfTest 
{
    private File _originalFile;
    private PDDocument _originalDocument;
    private String _password;
    private CryptoPdf _cryptoPdf;
    private String _testDataPath;
    private String _pfxFilePath;
    private String _pfxFilePassword;

    @BeforeEach                                         
    public void setUp() throws IOException {
        _cryptoPdf = new CryptoPdf();
        _testDataPath = "D:/workspace/cryptography-in-use/test-data";
        _originalFile = new File(_testDataPath + "/pdf/plain_document.pdf");
        _originalDocument = Loader.loadPDF(_originalFile);
        _password = "123456";
        _pfxFilePath = _testDataPath + "/private/signer_bundle.pfx";
        _pfxFilePassword = "123456";
    }

    @Test
    @DisplayName("Encrypt a PDF document")
    public void encryptDocumentTest() throws IOException
    {
        PDDocument cipheredDocument = new PDDocument(_originalDocument.getDocument());
        Boolean result = _cryptoPdf.encryptDocument(_originalDocument, 
                                                    _password,
                                                    cipheredDocument);
        Assertions.assertTrue(result);

        cipheredDocument.save(_testDataPath + "/pdf/ciphered_document.pdf");
        cipheredDocument.close();
    }

    @Test
    @DisplayName("Sign a PDF document")
    public void signDocumentTest() throws FileNotFoundException {
        int result = _cryptoPdf.loadPrivateKey(_pfxFilePath, _pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        File signedFile = new File(_testDataPath + "/pdf/signed_document.pdf");
        FileOutputStream signedFileOutputStream = new FileOutputStream(signedFile);
        Boolean signResult = _cryptoPdf.signDocument(_originalDocument, signedFileOutputStream);
        Assertions.assertTrue(signResult);
    }

    @Test
    @DisplayName("Double Sign a PDF document")
    public void doubleSignDocumentTest() throws FileNotFoundException, IOException {
        File signedFile = new File(_testDataPath + "/pdf/signed_document.pdf");
        PDDocument signedDocument = Loader.loadPDF(signedFile);
        String pfxFilePath = _testDataPath + "/private/second_signer_bundle.pfx";
        String pfxFilePassword = "123456";

        CryptoPdf cryptoPdf = new CryptoPdf();
        int result = cryptoPdf.loadPrivateKey(pfxFilePath, pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        File doubleSignedFile = new File(_testDataPath + "/pdf/double_signed_document.pdf");
        FileOutputStream doubleSignedFileOutputStream = new FileOutputStream(doubleSignedFile);
        Boolean signResult = cryptoPdf.signDocument(signedDocument, doubleSignedFileOutputStream);
        Assertions.assertTrue(signResult);
    }

    @Test
    @DisplayName("Sign a PDF document and encrypt it as a file")
    public void encryptSignedDocumentTest() throws FileNotFoundException {
        int result = _cryptoPdf.loadPrivateKey(_pfxFilePath, _pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        File signedFile = new File(_testDataPath + "/pdf/signed_document.pdf");
        FileOutputStream signedFileOutputStream = new FileOutputStream(signedFile);
        Boolean signResult = _cryptoPdf.signDocument(_originalDocument, signedFileOutputStream);
        Assertions.assertTrue(signResult);

        String  keyBase64 = "QNV2GQxfFWXwmZTWmoJrSxYNLmqTUxv9g5NeQpabc7E=";
        String  ivBase64 = "0eQbwlW32F6wbv7ca2n8bg==";
        File cipheredFile = new File(_testDataPath + "/pdf/ciphered_signed_file.pdf");
        Boolean cipherResult = _cryptoPdf.encrypt_aes_256_cbc_pkcs5(signedFile, 
                                                                    keyBase64,
                                                                    ivBase64, 
                                                                    cipheredFile);
        Assertions.assertTrue(cipherResult);
    }
}
