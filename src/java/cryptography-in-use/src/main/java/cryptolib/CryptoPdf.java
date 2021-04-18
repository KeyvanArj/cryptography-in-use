package cryptolib;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;

public class CryptoPdf extends CryptoFile {

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
}
