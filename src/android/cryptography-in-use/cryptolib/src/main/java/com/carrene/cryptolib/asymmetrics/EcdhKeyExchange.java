package com.carrene.cryptolib.asymmetrics;

import java.security.InvalidKeyException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PublicKey;
import java.security.Security;

import javax.crypto.KeyAgreement;

public class EcdhKeyExchange {

    public EcdhKeyExchange() {
    }

    public int deriveAes256SharedSecretKey(String provider,
                                           PublicKey serverPublicKey,
                                           EcKeyPair clientPrivateKey,
                                           byte[] sharedSecretKey) throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, KeyStoreException {
        KeyAgreement keyAgreement = KeyAgreement.getInstance("ECDH", provider);
        System.out.println(keyAgreement.getProvider().getName());
        keyAgreement.init(clientPrivateKey.getPrivateKey());
        keyAgreement.doPhase(serverPublicKey, true);
        byte[] secretKey = keyAgreement.generateSecret();
        System.arraycopy(secretKey, 0,
                sharedSecretKey, 0, secretKey.length);
        return 0;
    }
}
