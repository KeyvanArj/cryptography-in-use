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
  
//        let clientPublicKey = SecKeyCopyPublicKey(clientPrivateKey)
//        let publicKeyData = SecKeyCopyExternalRepresentation(clientPublicKey!, nil)! as Data
//        print("Client Public Key : ", publicKeyData.hexString())
        
        // Load the server public key
        let serverPem = "MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEk1qnJZfju7Cs3mcFHkaNv30Y14EXwLpQUpi1k2W+KWVSb1dnBTkavBRZ8bp0Ip1NR59PwuN/9Nf1pKu77a3PaQ=="
        let serverPemData = "04935AA72597E3BBB0ACDE67051E468DBF7D18D78117C0BA505298B59365BE2965526F576705391ABC1459F1BA74229D4D479F4FC2E37FF4D7F5A4ABBBEDADCF69".hexaData
        print("Server Public Key : ", serverPemData.hexString())
        
        let options: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                      kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                      kSecAttrKeySizeInBits as String: 256]
        guard let serverPublicKey = SecKeyCreateWithData(serverPemData as CFData,
                                                         options as CFDictionary,
                                                         &error) else {
            throw error!.takeRetainedValue() as Error
        }
        _keyExchange = KeyExchange(serverPublicKey: serverPublicKey, clientPrivateKey: clientPrivateKey)
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
