//
//  BitStringTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/14/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class BitStringTests: XCTestCase {

    var binaryData = Data([0x30, 0x31, 0x32, 0x33, 0x34, 0x35])
    var longBinaryData = Data([0x0A])
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        // This is redicioulous
        longBinaryData.append(contentsOf: repeatElement(0x0A, count: 255))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBitStringEncoding() throws {
        let bitString = BitString(data: self.binaryData)
        let encodedData = try bitString.asn1encode(tag: nil).serialize().hexString()
        
        // https://kjur.github.io/jsrsasign/tool/tool_asn1encoder.html
        // {"bitstr": {"hex": "00303132333435"}}
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "030700303132333435".uppercased())
    
    }
    
    func testLongBitStringEncoding() throws {
        let bitString = BitString(data: self.longBinaryData)
        let encodedData = try bitString.asn1encode(tag: nil).serialize().hexString()
        
        // print("stringData : ", stringData)
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "03820101000A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A".uppercased())
    
    }

    func testExplicitBitStringEncoding() throws {
        let bitString = BitString(data: self.binaryData, explicit: true)
        let encodedData = try bitString.asn1encode(tag: nil).serialize().hexString()
        
        // https://kjur.github.io/jsrsasign/tool/tool_asn1encoder.html
        // {"tag" : {"explicit" : true, "obj" : {"bitstr" : {"hex": "00303132333435"}}}}
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "a009030700303132333435".uppercased())
    }
    
    func testExplicitLongBitStringEncoding() throws {
        let bitString = BitString(data: self.longBinaryData, explicit: true)
        let encodedData = try bitString.asn1encode(tag: nil).serialize().hexString()
        
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "A082010503820101000A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A".uppercased())
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
