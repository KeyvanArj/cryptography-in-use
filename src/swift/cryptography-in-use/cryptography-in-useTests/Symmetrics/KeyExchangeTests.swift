//
//  KeyExchangeTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 6/11/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class KeyExchangeTests: XCTestCase {
    
    private var _keyExchange : KeyExchange!
    
    override func setUpWithError() throws {
        var error: Unmanaged<CFError>?
        
        // Generate a key-pair for client
        let keyPairAttr:[String : Any] = [kSecAttrKeySizeInBits as String: 256,
                                          kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                          kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: false],
                                          kSecPublicKeyAttrs as String:[kSecAttrIsPermanent as String: false]]
        guard let clientPrivateKey = SecKeyCreateRandomKey(keyPairAttr as CFDictionary, &error) else {
            throw error!.takeRetainedValue() as Error
        }
  
        let clientPublicKey = SecKeyCopyPublicKey(clientPrivateKey)
        let publicKeyData = SecKeyCopyExternalRepresentation(clientPublicKey!, nil)! as Data
        let algorithmIdentifier = SignatureAlgorithmIdentifier(algorithm : OID.ecPublicKey.rawValue, parameter: OID.prime256v1.rawValue)
        let subjectPublicKey = BitString(data: publicKeyData)
        let clientPublicKeyInfo = SubjectPublicKeyInfo(algorithm: algorithmIdentifier, subjectPublicKey: subjectPublicKey)
        print("Client Public Key : ", clientPublicKeyInfo.pem())
        
        // Load the server public key
        let serverPublicKeyPem = "-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEzDz8I0Spl1E7o68NS2FAAfP+/A5M\nABunlrWNejIo1PaIb8o0a5iENmDdz0ioWkd2I4jUXmuIbkFo7DsYwzddEg==\n-----END PUBLIC KEY-----\n"
        let serverPublicKeyInfo = SubjectPublicKeyInfo.from(pem: serverPublicKeyPem)!
        let serverPublicKeyData = serverPublicKeyInfo.subjectPublicKey!.binaryData
        _keyExchange = KeyExchange(serverPublicKeyData: serverPublicKeyData, clientPrivateKey: clientPrivateKey)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAes256KeyExchange() throws {
        let sharedSecretKey : Data = self._keyExchange.deriveAes256SharedSecretKey()
        print("shared secret key: ", sharedSecretKey.hexString())
        print("shared secret key length (Bits): ", sharedSecretKey.count * 8)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
