//
//  IntegerTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/23/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class IntegerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testByteArray2IntegerEncoding() throws {
        let data = Data([0x2A, 0x56, 0xF6, 0xA3, 0xDE, 0xEC, 0x8D, 0x40])
        let intValue = Int(bigEndian: data.withUnsafeBytes {$0.load(as: Int.self)})
        
        print("data : ", data.hexString())
        print("integer value : ", intValue)
        XCTAssertTrue(intValue == 3050896981270236480)
        
        let encodedData = try intValue.asn1encode(tag: nil).serialize()
        print("encoded value", encodedData)
                
        XCTAssertTrue(encodedData.hexString() == "02082a56F6a3deec8d40".uppercased())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
