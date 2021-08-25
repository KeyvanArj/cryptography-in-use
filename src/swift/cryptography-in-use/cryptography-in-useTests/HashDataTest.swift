//
//  HashDataTest.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/25/1400 AP.
//

import XCTest
import CryptoKit

class HashDataTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let sampleString = "00010203040506070809"
        let sampleData = Data(sampleString.utf8)
        let hashedData = SHA256.hash(data: sampleData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
        XCTAssertTrue(hashString == "713bf898faa2588baac01468cca272ffacad71645e30ef6da3da2424c7cb26d9")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
