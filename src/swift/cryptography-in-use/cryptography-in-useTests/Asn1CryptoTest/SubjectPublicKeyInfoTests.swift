//
//  SubjectPublicKeyInfo.swift
//  cryptography-in-useTests
//
//  Created by Keyvan Arj on 9/2/21.
//

import XCTest
@testable import cryptography_in_use

class SubjectPublicKeyInfoTests: XCTestCase {

    let _publicKeyPem = "-----BEGIN PUBLIC KEY-----\nMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEk1qnJZfju7Cs3mcFHkaNv30Y14EX\nwLpQUpi1k2W+KWVSb1dnBTkavBRZ8bp0Ip1NR59PwuN/9Nf1pKu77a3PaQ==\n-----END PUBLIC KEY-----"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPublicKeyInfoPemDecoding() throws {
        var subjectPublicKeyInfoBase64 = _publicKeyPem.replacingOccurrences(of: "\n", with: "")
        subjectPublicKeyInfoBase64 = subjectPublicKeyInfoBase64.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
        subjectPublicKeyInfoBase64 = subjectPublicKeyInfoBase64.replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
//        print("Subject Public Key Base 64 : ", subjectPublicKeyInfoBase64)
        
        let subjectPublicKeyInfoDer = Data(base64Encoded: subjectPublicKeyInfoBase64)!
        let asn1 = try! ASN1Decoder.decode(asn1: subjectPublicKeyInfoDer)
        let subjectPublicKeyInfo = SubjectPublicKeyInfo.asn1decode(asn1: asn1)!
        print("algorithm : ", OID.init(rawValue: (subjectPublicKeyInfo.algorithmIdentifier?.algorithm)!.rawValue)!)
        print("parameter : ", OID.init(rawValue: (subjectPublicKeyInfo.algorithmIdentifier?.parameter)!.rawValue)!)
        print("public key : " , subjectPublicKeyInfo.subjectPublicKey!.binaryData.hexString())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
