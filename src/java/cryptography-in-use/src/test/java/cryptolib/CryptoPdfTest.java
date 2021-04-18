package cryptolib;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Assertions;

import java.io.File;
import java.io.IOException;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;

/**
 * Unit test for CryptoPdf library.
 */
public class CryptoPdfTest 
{
    private PDDocument _originalDocument;
    private String _password;
    private CryptoPdf _cryptoPdf;
    private String _testDataPath;

    @BeforeEach                                         
    public void setUp() throws IOException {
        _cryptoPdf = new CryptoPdf();
        _testDataPath = "D:/workspace/cryptography-in-use/test-data";
        File originalFile = new File(_testDataPath + "/pdf/plain_document.pdf");
        _originalDocument = Loader.loadPDF(originalFile);
        _password = "123456";
    }

    @Test
    @DisplayName("Encrypt a PDF document")
    public void encryptPdfDocumentTest() throws IOException
    {
        PDDocument cipheredDocument = new PDDocument(_originalDocument.getDocument());
        Boolean result = _cryptoPdf.encrypt(_originalDocument, 
                                            _password,
                                            cipheredDocument);
        Assertions.assertTrue(result);

        cipheredDocument.save(_testDataPath + "/pdf/ciphered_document.pdf");
        cipheredDocument.close();
    }
}
