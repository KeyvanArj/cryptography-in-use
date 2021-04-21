package cryptolib;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class CryptoFile extends CryptoObject {
    
    public Boolean encrypt_aes_256_cbc_pkcs5(File plainFile, 
                                            String keyBase64,
                                            String ivBase64, 
                                            File cipheredFile) {

        try
        {
            if (plainFile == null || !plainFile.exists())
                return false;

            FileInputStream plainStream = new FileInputStream(plainFile);
            byte[] plainBytes = new byte[(int) plainFile.length()];
            plainStream.read(plainBytes);

            byte[] cipheredBytes = super.encrypt_aes_256_cbc_pkcs5(plainBytes, keyBase64, ivBase64);

            FileOutputStream cipheredStream = new FileOutputStream(cipheredFile);
            cipheredStream.write(cipheredBytes);

            plainStream.close();
            cipheredStream.close();

            return true;
        } catch(IOException ex) {
            return false;
        }
    }
}
