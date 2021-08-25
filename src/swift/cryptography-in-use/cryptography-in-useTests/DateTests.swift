//
//  DateTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/21/1400 AP.
//

import XCTest

class DateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGeneralisedDateEncoding() throws {
        let date = Date(timeIntervalSince1970: 1550832076)
        let encodedData = try date.asn1encode(tag: .universal(.utcTime)).serialize().hexString()
        
        // https://kjur.github.io/jsrsasign/tool/tool_asn1encoder.html
        // {"utctime": "1550832076"}
        print("Date : ", date)
        print("Encoded Data : ", encodedData)
        XCTAssertTrue(encodedData == "170d3139303232323130343131365a".uppercased())
    
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
