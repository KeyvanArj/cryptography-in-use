//
//  KeyUsageExtensionTest.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class KeyUsageExtensionTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testKeyUsageExtensionEncoding() throws {
        let keyUsageArray = [true, true, true, true, false, true, true, true, true]//x509Certificate.keyUsage
        let keyUsageExtension = KeyUsageExtension(value: keyUsageArray)
        XCTAssertTrue(try! keyUsageExtension.asn1encode(tag: nil).serialize().hexString() == "300F0603551D0F0101FF0405030307F780")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
