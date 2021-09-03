//
//  ValidityTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/21/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class ValidityTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneralisedDateEncoding() throws {
        let notBefore = Date(timeIntervalSince1970: 1550832076)
        let notAfter = Date(timeIntervalSince1970: 1551832076)
        let validity = Validity(notBefore: notBefore, notAfter: notAfter)
        let encodedData = try validity.asn1encode(tag: .universal(.utcTime)).serialize().hexString()
        
        print("Not Before : ", notBefore)
        print("Not After : ", notAfter)
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "301e170d3139303232323130343131365a170d3139303330363030323735365a".uppercased())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
