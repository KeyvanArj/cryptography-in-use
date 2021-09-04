//
//  TimeStampReqTests.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/30/1400 AP.
//

import XCTest
import CryptoKit
@testable import cryptography_in_use

class TimeStampReqTests: XCTestCase {

    let sampleDocument = "09128894558:C463213C-3332-4F31-BE5B-86EB51961A93"
    let baseURL = URL(string: "https://zoomid.hamrahkish.com/camel/organizations/mellipass/v1/timestamp")!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimeStampRequest() throws {
        // MessageImprint
        let hashAlgorithm = SignatureAlgorithmIdentifier(algorithm: OID.sha256.rawValue)
        let data = sampleDocument.data(using: .utf8)!
        let hash = SHA256.hash(data: data).compactMap{ String(format: "%02x", $0) }.joined()
        let hashData = hash.hexaData
        let hashMessage = OctetString(data: hashData, tag: nil)
        let messageImprint = MessageImprint(hashAlgorithm: hashAlgorithm, hashedMessage: hashMessage)
        let nonce = Int.random(in: 1..<Int.max)
        let timeStampReq = TimeStampReq(version: CmsVersion.v1.rawValue, messageImprint: messageImprint, nonce: nonce)
        
        print("TimeStampRequest : ", try timeStampReq.asn1encode(tag: nil).serialize().hexString())
        
        let binaryTimeStamp = try timeStampReq.asn1encode(tag: nil).serialize()
        
        // Call the WEB API to get the time stamp response
        testDownloadWebData(to: self.baseURL, body: binaryTimeStamp) { (result) in
            print(result)
        }
    }

    func testDownloadWebData(to url: URL, body: Data, then handler: @escaping (Result<Data, Error>) -> Void) {

        let expectation = XCTestExpectation(description: "Download hamrahkish.com timeStamp")
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        
        request.httpMethod = "POST"
        request.httpBody = body

        // Create a background task to download the web page.
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            let response = response as? HTTPURLResponse
            if response?.statusCode == 200 {
                print(response)
                XCTAssertNotNil(data, "No data was downloaded.")
                expectation.fulfill()
            } else {
                
            }
        })
        dataTask.resume()
        wait(for: [expectation], timeout: 10.0)
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

