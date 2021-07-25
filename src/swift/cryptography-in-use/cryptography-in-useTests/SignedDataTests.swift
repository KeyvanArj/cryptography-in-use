//
//  cryptography_in_useTests.swift
//  cryptography-in-useTests
//
//  Created by Keyvan Arj on 6/26/21.
//

import XCTest
@testable import cryptography_in_use

class SignedDataTests: XCTestCase {

    var _cms : ContentInfo!
    
    override func setUpWithError() throws {
        // Put setup code here.
        self._cms = ContentInfo(contentType: Oid.SignedData)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testContentType() throws {
        XCTAssertTrue(self._cms._contentType.rawValue == "1.2.840.113549.1.7.2")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
