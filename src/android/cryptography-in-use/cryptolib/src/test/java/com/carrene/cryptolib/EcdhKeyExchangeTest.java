package com.carrene.cryptolib;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;

import com.carrene.cryptolib.asymmetrics.EcKeyPair;
import com.carrene.cryptolib.asymmetrics.EcdhKeyExchange;

import java.io.File;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PublicKey;
import java.security.Security;
import java.security.UnrecoverableEntryException;
import java.security.cert.CertificateException;
import java.security.spec.InvalidKeySpecException;

import org.apache.commons.codec.binary.Hex;

public class EcdhKeyExchangeTest {

    private EcdhKeyExchange _ecdhKeyExchange;
    private PublicKey _serverPublicKey;
    private EcKeyPair _clientPrivateKey;

    @Before
    public void setup() throws CertificateException,
            UnrecoverableEntryException,
            NoSuchAlgorithmException,
            KeyStoreException,
            IOException, InvalidKeySpecException {
        this._ecdhKeyExchange = new EcdhKeyExchange();
        this._clientPrivateKey = new EcKeyPair("PKCS12");
        String pfxFilePath = "D:/workspace/cryptography-in-use/test-data/private/client-ec-bundle.pfx";
        String pfxFilePassword = "123456";
        this._clientPrivateKey.loadPfxPrivateKey(pfxFilePath, pfxFilePassword);
        String publicKeyFilePath = "D:/workspace/cryptography-in-use/test-data/certs/server-ec-public-key.pem";
        this._serverPublicKey = EcKeyPair.loadPemPublicKey(new File(publicKeyFilePath));
    }

    @Test
    public void deriveAes256SharedSecretKeyTest() throws NoSuchAlgorithmException, InvalidKeyException, NoSuchProviderException, KeyStoreException {
        byte[] sharedSecretKey = new byte[32];
        int result = this._ecdhKeyExchange.deriveAes256SharedSecretKey("SunEC",
                                                                      this._serverPublicKey,
                                                                      this._clientPrivateKey,
                                                                      sharedSecretKey);
        assertEquals(result, 0);
        System.out.println("Shared Secret Key : " + Hex.encodeHexString(sharedSecretKey));
    }
}