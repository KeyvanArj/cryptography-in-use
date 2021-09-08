package com.carrene.cryptography_in_use;

import android.content.Context;
import android.security.keystore.KeyGenParameterSpec;
import android.security.keystore.KeyProperties;
import android.util.Log;

import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.*;

import com.carrene.cryptography_in_use.asymmetrics.EcKeyPair;
import com.carrene.cryptography_in_use.asymmetrics.EcdhKeyExchange;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.net.URL;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.Provider;
import java.security.PublicKey;
import java.security.UnrecoverableEntryException;
import java.security.cert.CertificateException;
import java.security.spec.ECGenParameterSpec;
import java.security.spec.InvalidKeySpecException;

/**
 * Instrumented test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
@RunWith(AndroidJUnit4.class)
public class EcdhKeyExchangeInstrumentedTest {

    private Provider _provider;
    private EcdhKeyExchange _ecdhKeyExchange;
    private EcKeyPair _clientPrivateKey;
    private PublicKey _serverPublicKey;

    @Before
    public void setup() throws CertificateException,
            InvalidAlgorithmParameterException,
            NoSuchAlgorithmException,
            KeyStoreException,
            NoSuchProviderException,
            UnrecoverableEntryException,
            IOException, InvalidKeySpecException, URISyntaxException {
        String alias = "key-agreement";
        this._clientPrivateKey = new EcKeyPair("AndroidKeyStore");
        this._ecdhKeyExchange = new EcdhKeyExchange();
        this._clientPrivateKey.generateKeyPair("key-agreement");
        ClassLoader classLoader = this.getClass().getClassLoader();
        String publicKeyFilePath = classLoader.getResource("server-ec-public-key.pem").getPath();
        File publicKeyFile = new File(publicKeyFilePath);
        assertNotNull(publicKeyFile);
        assertTrue(publicKeyFile.isFile() );
        assertTrue(publicKeyFile.exists() );
        this._serverPublicKey = EcKeyPair.loadPemPublicKey(new File(publicKeyFilePath));
    }

    @Test
    public void testDeriveEcdhSharedSecretKey() throws NoSuchAlgorithmException, InvalidKeyException {
        byte[] sharedSecretKey = new byte[32];
        int result = this._ecdhKeyExchange.deriveAes256SharedSecretKey(this._serverPublicKey,
                this._clientPrivateKey,
                sharedSecretKey);
        assertTrue(result == 0);
        System.out.println("Shared Secret Key : " + Hex.encodeHexString(sharedSecretKey));
    }
}