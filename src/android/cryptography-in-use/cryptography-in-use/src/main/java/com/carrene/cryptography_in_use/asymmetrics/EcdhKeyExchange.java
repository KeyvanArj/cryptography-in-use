package com.carrene.cryptography_in_use.asymmetrics;

import static com.carrene.cryptography_in_use.Errors.NoError;

import android.os.Build;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;

import androidx.annotation.RequiresApi;

import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.Array;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.KeyStore.PrivateKeyEntry;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PublicKey;
import java.security.UnrecoverableEntryException;
import java.security.cert.CertificateException;
import java.security.spec.ECGenParameterSpec;
import java.util.Enumeration;

import javax.crypto.KeyAgreement;

public class EcdhKeyExchange {

    public EcdhKeyExchange() {
    }

    public int deriveAes256SharedSecretKey(PublicKey serverPublicKey,
                                           EcKeyPair clientPrivateKey,
                                           byte[] sharedSecretKey) throws InvalidKeyException, NoSuchAlgorithmException {

        KeyAgreement keyAgreement = KeyAgreement.getInstance("ECDH");
        keyAgreement.init(clientPrivateKey.getPrivateKey());
        keyAgreement.doPhase(serverPublicKey, true);
        byte[] secretKey = keyAgreement.generateSecret();
        System.arraycopy(secretKey, 0,
                sharedSecretKey, 0, secretKey.length);
        return 0;
    }
}
