//
//  SignedAttrsTest.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import XCTest
@testable import cryptography_in_use
import CryptoKit

class SignedAttrsTest: XCTestCase {

    let _sampleDocument = "09128894558:C463213C-3332-4F31-BE5B-86EB51961A93"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignedAttrsEncoding() throws {
        // Content Type
        let contentTypeAttribute = ContentTypeAttribute(value: OID.pkcs7data.rawValue)
                
        // Signing Time
        let signingTimeAttribute = SigningTimeAttribute(value: Date(timeIntervalSince1970: 1631942076))
        
        // CMS Algorithm Protection
        let cmsAlgorithmProtectionAttribute = CMSAlgorithmProtectionAttribute(digestAlgorithmId: DigestAlgorithmId.sha256,
                                                                              signatureAlgorithmId: SignatureAlgorithmId.sha256_ecdsa)
        
        //MessageDigest
        let data = self._sampleDocument.data(using: .utf8)!
        let hash = SHA256.hash(data: data).compactMap{ String(format: "%02x", $0) }.joined()
        let messageDigestAttribute = MessageDigestAttribute(value: hash)
        
        let signedAttributes = SignedAttributes(tag: 0x00)
        signedAttributes.add(value: contentTypeAttribute)
        signedAttributes.add(value: signingTimeAttribute)
        signedAttributes.add(value: cmsAlgorithmProtectionAttribute)
        signedAttributes.add(value: messageDigestAttribute)
        
        XCTAssertTrue(try signedAttributes.asn1encode(tag: nil).serialize().hexString() == "A08193301806092A864886F70D010903310B06092A864886F70D010701301C06092A864886F70D010905310F170D3231303931383035313433365A302806092A864886F70D010934311B3019300B0609608648016503040201A10A06082A8648CE3D040302302F06092A864886F70D01090431220420665000E0D7203E4AEF13B21950DA7327512D3F2556B5691802A4107AE050593C")
        
        XCTAssertTrue(signedAttributes.serialize().hexString() == "318193301806092A864886F70D010903310B06092A864886F70D010701301C06092A864886F70D010905310F170D3231303931383035313433365A302806092A864886F70D010934311B3019300B0609608648016503040201A10A06082A8648CE3D040302302F06092A864886F70D01090431220420665000E0D7203E4AEF13B21950DA7327512D3F2556B5691802A4107AE050593C")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
