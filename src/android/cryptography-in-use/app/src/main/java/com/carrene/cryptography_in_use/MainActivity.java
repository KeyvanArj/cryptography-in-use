package com.carrene.cryptography_in_use;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Build;
import android.os.Bundle;

import com.carrene.cryptolib.asymmetrics.EcKeyPair;
import com.carrene.cryptolib.asymmetrics.EcdhKeyExchange;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PublicKey;
import java.security.UnrecoverableEntryException;
import java.security.cert.CertificateException;
import java.security.spec.InvalidKeySpecException;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.binary.Hex;

public class MainActivity extends AppCompatActivity {

    private EcdhKeyExchange _ecdhKeyExchange;
    private EcKeyPair _clientPrivateKey;
    private PublicKey _serverPublicKey;

    @RequiresApi(api = Build.VERSION_CODES.P)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

       initEcdh();
       generateSharedSecretKey();
    }

    @RequiresApi(api = Build.VERSION_CODES.P)
    private void initEcdh() {
        try {
            String alias = "key-agreement2";
            this._clientPrivateKey = new EcKeyPair("AndroidKeyStore");
            this._ecdhKeyExchange = new EcdhKeyExchange();
            this._clientPrivateKey.generateKeyPair(alias);
            String serverPublicKey = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAElUM4pGyoILNSxjAl3Dvr6PTiZXu5" +
                    "jhDp20neJEqH1KspMNtj9uQCzRmoYf/m0VtFBvtk4CnTEnDpKDxTZMbM9A==";
            byte[] content = Base64.decodeBase64(serverPublicKey);
            this._serverPublicKey = EcKeyPair.getPublicKey(content, "EC");
        } catch (KeyStoreException e) {
            e.printStackTrace();
        } catch (CertificateException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (UnrecoverableEntryException e) {
            e.printStackTrace();
        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        } catch (InvalidAlgorithmParameterException e) {
            e.printStackTrace();
        } catch (InvalidKeySpecException e) {
            e.printStackTrace();
        }
    }

    private void generateSharedSecretKey() {
        byte[] sharedSecretKey = new byte[32];
        try {
            int result = this._ecdhKeyExchange.deriveAes256SharedSecretKey("AndroidKeyStore",
                                                                            this._serverPublicKey,
                                                                            this._clientPrivateKey,
                                                                            sharedSecretKey);
            System.out.println("Client Public Key : " + Base64.encodeBase64String(this._clientPrivateKey.getPublicKey()));
            System.out.println("Shared Secret Key : " + Hex.encodeHexString(sharedSecretKey));
        } catch (InvalidKeyException e) {
            e.printStackTrace();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (NoSuchProviderException e) {
            e.printStackTrace();
        } catch (KeyStoreException e) {
            e.printStackTrace();
        }
    }
}