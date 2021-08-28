//
//  OctetStringTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/12/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class OctetStringTests: XCTestCase {

    let binaryData = Data([0x30, 0x31, 0x32, 0x33, 0x34, 0x35])
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOctetStringEncoding() throws {
        let octetString = OctetString(data: binaryData, tag: nil)
        let encodedData = try octetString.asn1encode(tag: nil).serialize().hexString()
        
        // https://kjur.github.io/jsrsasign/tool/tool_asn1encoder.html
        // {"octstr" : "012345"}
        // print("stringData : ", stringData)
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "0406303132333435".uppercased())
    
    }

    func testExplicitOctetStringEncoding() throws {
        let octetString = OctetString(data: binaryData, explicit: true, tag: nil)
        let encodedData = try octetString.asn1encode(tag: nil).serialize().hexString()
        
        // https://kjur.github.io/jsrsasign/tool/tool_asn1encoder.html
        // {"tag" : {"explicit" : true, "obj" : {"octstr" : "012345"}}}
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "a0080406303132333435".uppercased())
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
