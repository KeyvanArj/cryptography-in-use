package cryptolib;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Enumeration;

import java.security.cert.X509Certificate;
import java.security.PrivateKey;
import java.security.UnrecoverableKeyException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateParsingException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.InvalidKeyException;
import java.security.InvalidAlgorithmParameterException;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;

import java.util.Base64;

public class CryptoObject {

    public static final int NO_ERROR = 0;
    public static final int ERROR_EXCEPTION = 100;
    public static final int ERROR_CERTIFICATE_CHAIN_NOT_FOUND = 101;
    public static final int ERROR_CERTIFICATE_IS_NOT_X509 = 102;
    public static final int ERROR_CERTIFICATE_USAGE = 103;
    public static final int ERROR_CERTIFICATE_EXTENDED_USAGE = 104;

    protected PrivateKey _privateKey;
    protected Certificate[] _certificateChain;

    public CryptoObject() {

    }

    public byte[] encrypt_aes_256_cbc_pkcs5(byte[] plainBytes,
                                            String keyBase64,
                                            String ivBase64) {
        try
        {
            byte[] keyBytes = Base64.getDecoder().decode(keyBase64);
            SecretKeySpec secretKeySpec = new SecretKeySpec(keyBytes, "AES");

            byte[] ivBytes = Base64.getDecoder().decode(ivBase64);
            IvParameterSpec ivParameterSpec = new IvParameterSpec(ivBytes);

            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec, ivParameterSpec);

            byte[] cipheredBytes = cipher.doFinal(plainBytes);

            return cipheredBytes;
        } catch(NoSuchPaddingException | NoSuchAlgorithmException
                | InvalidKeyException | BadPaddingException | InvalidAlgorithmParameterException
                | IllegalBlockSizeException ex) {
            return null;
        }
    }

    public int loadPrivateKey(String pfxFilePath, String password) {
        try {
            KeyStore keystore = KeyStore.getInstance("PKCS12");
            keystore.load(new FileInputStream(pfxFilePath), password.toCharArray());
            Enumeration<String> aliases = keystore.aliases();
            if (aliases.hasMoreElements())
            {
                String alias = aliases.nextElement();
                _privateKey = (PrivateKey) keystore.getKey(alias, password.toCharArray());
                _certificateChain = keystore.getCertificateChain(alias);
                if (_certificateChain == null)
                    return ERROR_CERTIFICATE_CHAIN_NOT_FOUND;
                Certificate certificate = _certificateChain[0];
                if (certificate instanceof X509Certificate)
                {
                    ((X509Certificate) certificate).checkValidity();
                    int result = this.checkCertificateUsage((X509Certificate) certificate);
                    if (result != NO_ERROR)
                        return result;         
                }
                else
                    return ERROR_CERTIFICATE_IS_NOT_X509;
            }
            return NO_ERROR;
        } catch (KeyStoreException | NoSuchAlgorithmException |
                 SecurityException | IOException |    
                 CertificateException | UnrecoverableKeyException ex) {
            return ERROR_EXCEPTION;
        }
    }

    public int checkCertificateUsage(X509Certificate x509Certificate) throws CertificateParsingException
    {
        // Check whether signer certificate is "valid for usage"
        // https://stackoverflow.com/a/52765021/535646
        // https://www.adobe.com/devnet-docs/acrobatetk/tools/DigSig/changes.html#id1
        boolean[] keyUsage = x509Certificate.getKeyUsage();
        if (keyUsage != null && !keyUsage[0] && !keyUsage[1])
        {
            // (unclear what "signTransaction" is)
            // https://tools.ietf.org/html/rfc5280#section-4.2.1.3
            // "Certificate key usage does not include  digitalSignature nor nonRepudiation");
            return ERROR_CERTIFICATE_USAGE;
        }
        
        return NO_ERROR;
    }
}
