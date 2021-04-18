package cryptolib;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;

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

public class CryptoPdf {

    public CryptoPdf() {

    }
    
    public Boolean encrypt(PDDocument plainDocument, 
                           String password, 
                           PDDocument cipheredDocument) {
        
        try
        {
            //Creating access permission object
            AccessPermission accessPermission = new AccessPermission();

            // Set if the user can modify the document to false
            accessPermission.setCanModify(false);

            //Creating StandardProtectionPolicy object
            StandardProtectionPolicy standardProtectionPolicy = new StandardProtectionPolicy(password, password, accessPermission);
    
            //Setting the length of the encryption key
            standardProtectionPolicy.setEncryptionKeyLength(128);
    
            //Setting the access permissions
            standardProtectionPolicy.setPermissions(accessPermission);
    
            //Protecting the document
            cipheredDocument.protect(standardProtectionPolicy);

            return true;
            
        } catch(Exception exception) {
            return false;
        }
    }

    public Boolean encrypt(File plainFile, 
                           String keyBase64,
                           String ivBase64, 
                           File cipheredFile) {
        
        try
        {
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
