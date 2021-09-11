package com.carrene.cryptolib.asymmetrics;

import static com.carrene.cryptolib.Errors.NoError;

import android.os.Build;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.util.Log;

import androidx.annotation.RequiresApi;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.KeyFactory;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.UnrecoverableEntryException;
import java.security.cert.CertificateException;
import java.security.spec.ECGenParameterSpec;
import java.security.spec.EncodedKeySpec;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Enumeration;

import org.bouncycastle.util.io.pem.PemObject;
import org.bouncycastle.util.io.pem.PemReader;

public class EcKeyPair {

    private String _provider;
    private KeyStore.PrivateKeyEntry _privateKey;

    public EcKeyPair(String provider) {
        this._provider = provider;
    }

    public PrivateKey getPrivateKey() {
        return this._privateKey.getPrivateKey();
    }

    public byte[] getPublicKey() {
        return this._privateKey.getCertificate().getPublicKey().getEncoded();
    }

    @RequiresApi(api = Build.VERSION_CODES.P)
    public int generateKeyPair(String alias) throws KeyStoreException,
            CertificateException,
            NoSuchAlgorithmException,
            IOException,
            UnrecoverableEntryException,
            NoSuchProviderException,
            InvalidAlgorithmParameterException {
        KeyStore keyStore = KeyStore.getInstance(this._provider);
        keyStore.load(null);

        if (!keyStore.containsAlias(alias)) {
            KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(
                    KeyProperties.KEY_ALGORITHM_EC,
                    this._provider);
            keyPairGenerator.initialize(
                    new KeyGenParameterSpec.Builder(
                            alias,
                            KeyProperties.PURPOSE_SIGN | KeyProperties.PURPOSE_VERIFY | KeyProperties.PURPOSE_ENCRYPT | KeyProperties.PURPOSE_DECRYPT)
                            .setAlgorithmParameterSpec(new ECGenParameterSpec("secp256r1"))
                            .setDigests(KeyProperties.DIGEST_SHA256)
                            .setRandomizedEncryptionRequired(true)
                            .setUnlockedDeviceRequired(true)
//                            .setUserAuthenticationRequired(true)
//                            .setUserPresenceRequired(true)
//                            .setIsStrongBoxBacked(true)
                            .build());
            keyPairGenerator.generateKeyPair();
        }
        this._privateKey = (KeyStore.PrivateKeyEntry) keyStore.getEntry(alias, null);

        return NoError;
    }

    public int loadPfxPrivateKey(String pfxFilePath, String password) throws KeyStoreException,
            IOException,
            CertificateException,
            NoSuchAlgorithmException, UnrecoverableEntryException {

        KeyStore keystore = KeyStore.getInstance(this._provider);
        keystore.load(new FileInputStream(pfxFilePath), password.toCharArray());
        Enumeration<String> aliases = keystore.aliases();
        if (aliases.hasMoreElements()) {
            String alias = aliases.nextElement();
            _privateKey = (KeyStore.PrivateKeyEntry) keystore.getEntry(alias,
                    new KeyStore.PasswordProtection(password == null ? null : password.toCharArray()));
        }
        return NoError;
    }

    public static PublicKey loadPemPublicKey(File publicKeyFile) throws IOException, InvalidKeySpecException, NoSuchAlgorithmException {
        byte[] bytes = parsePEMFile(publicKeyFile);
        return getPublicKey(bytes, "EC");
    }

    public static PrivateKey loadPemPrivateKey(String filepath) throws IOException, InvalidKeySpecException, NoSuchAlgorithmException {
        byte[] bytes = parsePEMFile(new File(filepath));
        return getPrivateKey(bytes, "EC");
    }

    private static byte[] parsePEMFile(File pemFile) throws IOException {
        if (!pemFile.isFile() || !pemFile.exists()) {
            throw new FileNotFoundException(String.format("The file '%s' doesn't exist.", pemFile.getAbsolutePath()));
        }
        PemReader reader = new PemReader(new FileReader(pemFile));
        PemObject pemObject = reader.readPemObject();
        byte[] content = pemObject.getContent();
        return content;
    }

    public static PublicKey getPublicKey(byte[] keyBytes, String algorithm) throws NoSuchAlgorithmException, InvalidKeySpecException {
        PublicKey publicKey = null;
        KeyFactory kf = KeyFactory.getInstance(algorithm);
        EncodedKeySpec keySpec = new X509EncodedKeySpec(keyBytes);
        publicKey = kf.generatePublic(keySpec);

        return publicKey;
    }

    private static PrivateKey getPrivateKey(byte[] keyBytes, String algorithm) throws NoSuchAlgorithmException, InvalidKeySpecException {
        PrivateKey privateKey = null;
        KeyFactory kf = KeyFactory.getInstance(algorithm);
        EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(keyBytes);
        privateKey = kf.generatePrivate(keySpec);
        return privateKey;
    }
}
