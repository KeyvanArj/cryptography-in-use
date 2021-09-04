//
//  KeyExchange.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/11/1400 AP.
//
import Foundation
import Security

class KeyExchange {
    
    private var _serverPublicKey : SecKey
    private var _clientPrivateKey : SecKey
    
    init(serverPublicKey: SecKey, clientPrivateKey: SecKey) {
        self._serverPublicKey = serverPublicKey
        self._clientPrivateKey = clientPrivateKey
    }
    
    func deriveAes256SharedSecretKey() -> Data {
        
        var error : Unmanaged<CFError>?
        
        let keyExchangeParameter : [String : Any] = [SecKeyKeyExchangeParameter.requestedSize.rawValue as String: 32]
        
        let algorithm:SecKeyAlgorithm = SecKeyAlgorithm.ecdhKeyExchangeStandardX963SHA256
        
        let shared : CFData? = SecKeyCopyKeyExchangeResult(self._clientPrivateKey,
                                                           algorithm,
                                                           self._serverPublicKey,
                                                           keyExchangeParameter as CFDictionary,
                                                           &error)
        let sharedSecretKey : Data = shared! as Data
        
        return sharedSecretKey
    }
}
