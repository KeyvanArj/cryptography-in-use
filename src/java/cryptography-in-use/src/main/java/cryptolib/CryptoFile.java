package cryptolib;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.InvalidAlgorithmParameterException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;

import java.util.Base64;

public class CryptoFile {
    
    public Boolean encrypt(File plainFile, 
                           String keyBase64,
                           String ivBase64, 
                           File cipheredFile) {

        try
        {
            if (plainFile == null || !plainFile.exists())
            return false;

            byte[] keyBytes = Base64.getDecoder().decode(keyBase64);
            SecretKeySpec secretKeySpec = new SecretKeySpec(keyBytes, "AES");

            byte[] ivBytes = Base64.getDecoder().decode(ivBase64);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(ivBytes);

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);

            FileInputStream plainStream = new FileInputStream(plainFile);
            byte[] plainBytes = new byte[(int) plainFile.length()];
            plainStream.read(plainBytes);

            byte[] cipheredBytes = cipher.doFinal(plainBytes);

            FileOutputStream cipheredStream = new FileOutputStream(cipheredFile);
            cipheredStream.write(cipheredBytes);

            plainStream.close();
            cipheredStream.close();

            return true;
        } catch(NoSuchPaddingException | NoSuchAlgorithmException
                | InvalidKeyException | BadPaddingException | InvalidAlgorithmParameterException
                | IllegalBlockSizeException | IOException ex) {
            return false;
        }
    }
}
