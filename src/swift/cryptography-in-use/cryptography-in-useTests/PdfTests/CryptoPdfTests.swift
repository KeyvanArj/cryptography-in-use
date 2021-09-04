//
//  CryptoPdfTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 6/7/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class CryptoPdfTests: XCTestCase {

    let TestDataPath = "/Users/mojtabamirzadeh/Workspace/cms-codec/cryptography-in-use/test-data"
    var _originalPdfPath : String!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self._originalPdfPath = TestDataPath + "/pdf/original_document.pdf"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReadPdfContent() throws {
        let cryptoPdf = CryptoPdf(path: self._originalPdfPath)
        XCTAssertTrue(cryptoPdf.size == 679)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
