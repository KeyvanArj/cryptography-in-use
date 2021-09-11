package com.carrene.cryptolib;

import androidx.test.ext.junit.runners.AndroidJUnit4;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.*;

import com.carrene.cryptolib.asymmetrics.EcKeyPair;
import com.carrene.cryptolib.asymmetrics.EcdhKeyExchange;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PublicKey;
import java.security.Security;
import java.security.UnrecoverableEntryException;
import java.security.cert.CertificateException;
import java.security.spec.InvalidKeySpecException;

/**
 * Instrumented test, which will execute on an Android device.
 *
 * @see <a href="http://d.android.com/tools/testing">Testing documentation</a>
 */
@RunWith(AndroidJUnit4.class)
public class EcdhKeyExchangeInstrumentedTest {

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
            IOException, InvalidKeySpecException {
        String alias = "key-agreement2";
        this._clientPrivateKey = new EcKeyPair("AndroidKeyStore");
        this._ecdhKeyExchange = new EcdhKeyExchange();
        this._clientPrivateKey.generateKeyPair(alias);

        String serverPublicKey = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAElUM4pGyoILNSxjAl3Dvr6PTiZXu5" +
                "jhDp20neJEqH1KspMNtj9uQCzRmoYf/m0VtFBvtk4CnTEnDpKDxTZMbM9A==";
        byte[] content = Base64.decodeBase64(serverPublicKey);
        this._serverPublicKey = EcKeyPair.getPublicKey(content, "EC");
    }

    @Test
    public void testDeriveEcdhSharedSecretKey() throws NoSuchAlgorithmException, InvalidKeyException, NoSuchProviderException, KeyStoreException {
        byte[] sharedSecretKey = new byte[32];
        int result = this._ecdhKeyExchange.deriveAes256SharedSecretKey("AndroidKeyStore",
                                                                        this._serverPublicKey,
                                                                        this._clientPrivateKey,
                                                                        sharedSecretKey);
        assertTrue(result == 0);
        System.out.println("Client Public Key : " + Base64.encodeBase64String(this._clientPrivateKey.getPublicKey()));
        System.out.println("Shared Secret Key : " + Hex.encodeHexString(sharedSecretKey));
    }
}