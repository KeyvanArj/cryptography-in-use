package cryptolib;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Assertions;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import java.awt.geom.Rectangle2D;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;

/**
 * Unit test for CryptoPdf library.
 */
public class CryptoPdfTest 
{
    private File originalFile;
    private PDDocument originalDocument;
    private String password;
    private CryptoPdf cryptoPdf;
    private String pfxFilePath;
    private String pfxFilePassword;

    @BeforeEach                                         
    public void setUp() throws IOException {
        cryptoPdf = new CryptoPdf();
        originalFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/original_document.pdf");
        originalDocument = Loader.loadPDF(originalFile);
        password = "123456";
        pfxFilePath = TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/private/signer_bundle.pfx";
        pfxFilePassword = "123456";
    }

    @Test
    @DisplayName("Encrypt a PDF document")
    public void encryptDocumentTest() throws IOException
    {
        PDDocument cipheredDocument = new PDDocument(originalDocument.getDocument());
        Boolean result = cryptoPdf.encryptDocument(originalDocument, 
                                                    password,
                                                    cipheredDocument);
        Assertions.assertTrue(result);

        cipheredDocument.save(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/ciphered_document.pdf");
        cipheredDocument.close();
    }

    @Test
    @DisplayName("Sign a PDF document")
    public void signDocumentTest() throws FileNotFoundException {
        int result = cryptoPdf.loadPrivateKey(pfxFilePath, pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        File signedFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/signed_document.pdf");
        FileOutputStream signedFileOutputStream = new FileOutputStream(signedFile);
        Boolean signResult = cryptoPdf.signDocument(originalDocument, signedFileOutputStream);
        Assertions.assertTrue(signResult);
    }

    @Test
    @DisplayName("Digitally and Visually Sign a PDF document")
    public void signWithVisualDocumentTest() throws FileNotFoundException {
        int result = cryptoPdf.loadPrivateKey(pfxFilePath, pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        File visualSignatureFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/signature/first_client_visual_signature.jpg");
        Rectangle2D visualRectangle = new Rectangle2D.Float(10, 20, 100, 100);

        File signedFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/visual_single_signed_document.pdf");
        FileOutputStream signedFileOutputStream = new FileOutputStream(signedFile);
        Boolean signResult = cryptoPdf.signWithVisualDocument(originalDocument, 
                                                               signedFileOutputStream, 
                                                               visualRectangle,
                                                               visualSignatureFile);
        Assertions.assertTrue(signResult);
    }

    @Test
    @DisplayName("Double Sign a PDF document")
    public void doubleSignDocumentTest() throws IOException {
        File signedFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/visual_signed_document.pdf");
        PDDocument signedDocument = Loader.loadPDF(signedFile);
        String pfxFilePath = TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/private/second_signer_bundle.pfx";
        String pfxFilePassword = "123456";

        CryptoPdf cryptoPdf = new CryptoPdf();
        int result = cryptoPdf.loadPrivateKey(pfxFilePath, pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        File visualSignatureFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/signature/second_client_visual_signature.jpg");
        Rectangle2D visualRectangle = new Rectangle2D.Float(120, 20, 100, 100);

        File doubleSignedFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/visual_double_signed_document.pdf");
        FileOutputStream doubleSignedFileOutputStream = new FileOutputStream(doubleSignedFile);
        Boolean signResult = cryptoPdf.signWithVisualDocument(signedDocument, 
                                                               doubleSignedFileOutputStream, 
                                                               visualRectangle,
                                                               visualSignatureFile);

        Assertions.assertTrue(signResult);
    }

    @Test
    @DisplayName("Sign a PDF document and encrypt it as a file")
    public void encryptSignedDocumentTest() throws FileNotFoundException {
        int result = cryptoPdf.loadPrivateKey(pfxFilePath, pfxFilePassword);
        Assertions.assertEquals(result, CryptoObject.NO_ERROR);

        File signedFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/signed_document.pdf");
        FileOutputStream signedFileOutputStream = new FileOutputStream(signedFile);
        Boolean signResult = cryptoPdf.signDocument(originalDocument, signedFileOutputStream);
        Assertions.assertTrue(signResult);

        String  keyBase64 = "QNV2GQxfFWXwmZTWmoJrSxYNLmqTUxv9g5NeQpabc7E=";
        String  ivBase64 = "0eQbwlW32F6wbv7ca2n8bg==";
        File cipheredFile = new File(TestConfig.CRYPTOGRAPHY_IN_USE_TEST_DATA_PATH + "/pdf/ciphered_signed_file.pdf");
        Boolean cipherResult = cryptoPdf.encrypt_aes_256_cbc_pkcs5(signedFile, 
                                                                    keyBase64,
                                                                    ivBase64, 
                                                                    cipheredFile);
        Assertions.assertTrue(cipherResult);
    }
}
