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
    
    init(serverPublicKeyData: Data, clientPrivateKey: SecKey) {
        
        let options: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                      kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                      kSecAttrKeySizeInBits as String: 256]
        
        self._serverPublicKey = SecKeyCreateWithData(serverPublicKeyData as CFData,
                                                     options as CFDictionary,
                                                     nil)!
        self._clientPrivateKey = clientPrivateKey
    }
    
    func deriveAes256SharedSecretKey() -> Data {
        
        var error : Unmanaged<CFError>?
        
        let keyExchangeParameter : [String : Any] = [SecKeyKeyExchangeParameter.requestedSize.rawValue as String: 32]
        
        let algorithm:SecKeyAlgorithm = SecKeyAlgorithm.ecdhKeyExchangeCofactor
        
        let shared : CFData? = SecKeyCopyKeyExchangeResult(self._clientPrivateKey,
                                                           algorithm,
                                                           self._serverPublicKey,
                                                           keyExchangeParameter as CFDictionary,
                                                           &error)
        let sharedSecretKey : Data = shared! as Data
        
        return sharedSecretKey
    }
}
