//
//  cryptography_in_useTests.swift
//  cryptography-in-useTests
//
//  Created by Keyvan Arj on 6/26/21.
//

import XCTest
import Foundation
import CryptoKit
@testable import cryptography_in_use

class SignedDataTests: XCTestCase {
    
    let _sampleDocument = "09128894558:C463213C-3332-4F31-BE5B-86EB51961A93"
    let _sampleSignature = "MEYCIQDtHcEWSlAgJVgCy0D73Ay7tS4DyHV8jVxQ5bzXE38rQgIhAIjTNDbbiI+mwebsSyeWcTf7j62WOANeYLy9p7bDHzdR"
    //"MEYCIQCY6ijeXKa7Ti3od9Nr6WlKKpfXfRn12sW6LnEYpjDAKgIhAIvZN78aZZ4exY9HzpII+sVHHGTVaNru0FtPXR46hPhG"
    var _signedData : SignedData!
    var _cms : ContentInfo!
    var _timeStampReq : TimeStampReq!
    
    let samplePEMcertificate = """
    -----BEGIN CERTIFICATE-----
    MIIFPzCCBCegAwIBAgIIE+J9P8Sl+9UwDQYJKoZIhvcNAQELBQAwgakxCzAJBgNV
    BAYTAklSMQ8wDQYDVQQIEwZUZWhyYW4xGTAXBgNVBAoTEE5vbi1Hb3Zlcm5tZW50
    YWwxEDAOBgNVBAsTB1RlY3Zlc3QxJDAiBgNVBAsTG1NtYXJ0IFRydXN0IEludGVy
    bWVkaWF0ZSBDQTE2MDQGA1UEAxMtU21hcnQgdHJ1c3QgcHJpdmF0ZSBpbnRlcm1l
    ZGlhdGUgYnJvbnplIENBLUczMB4XDTIxMDgwMzE0MTAxN1oXDTIzMDgwMzE0MTAx
    N1owgaAxCzAJBgNVBAYTAklSMRUwEwYDVQQKDAxVbmFmZmlsaWF0ZWQxFzAVBgNV
    BAQMDtmF2YrYsdiy2KfYr9mHMRkwFwYDVQQqDBDYs9mK2K/Zhdis2KrYqNmKMRMw
    EQYDVQQFEwowMDEyMzAwMzA2MRkwFwYDVQQDDBBtb2ppIG1pZXIgW3NpZ25dMRYw
    FAYJKoZIhvcNAQkBFgdtQG0uY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE
    lMTNv/EwpspWMZFMVSjRu+P4cpJ+gBoVb841B5+JfQl889wyTmCPHE3dBXDiDvQb
    hOSRItFHF7ZFV40cBZH2tqOCAjswggI3MB8GA1UdIwQYMBaAFEPB30Lp+bxc0AJl
    7+Hu5o96z8J7MFgGCCsGAQUFBwEBBEwwSjBIBggrBgEFBQcwAYY8aHR0cDovL29j
    c3AxLnNtYXJ0dHJ1c3Rjby5pci9lamJjYS9yZXRyaWV2ZS9jaGVja19zdGF0dXMu
    anNwMGMGA1UdIARcMFowWAYHYIJsZQEBATBNMEsGCCsGAQUFBwIBFj9odHRwczov
    L2NhLnNtYXJ0dHJ1c3Rjby5pci9pbmRleC5waHA/cmVzb3VyY2U9cGRmLWRsJnBk
    Zj0wMi5wZGYwEwYDVR0lBAwwCgYIKwYBBQUHAwIwggEPBgNVHR8EggEGMIIBAjCB
    /6BLoEmGR2h0dHBzOi8vY2Euc21hcnR0cnVzdGNvLmlyL2RsL2NydC9TbWFydHRy
    dXN0cHJpdmF0ZUludGVybWVkaWF0ZUNSTDEuY3JsooGvpIGsMIGpMTYwNAYDVQQD
    DC1TbWFydCB0cnVzdCBwcml2YXRlIGludGVybWVkaWF0ZSBzaWx2ZXIgQ0EtRzMx
    JDAiBgNVBAsMG1NtYXJ0IFRydXN0IEludGVybWVkaWF0ZSBDQTEQMA4GA1UECwwH
    VGVjdmVzdDEZMBcGA1UECgwQTm9uLUdvdmVybm1lbnRhbDEPMA0GA1UECAwGVGVo
    cmFuMQswCQYDVQQGEwJJUjAdBgNVHQ4EFgQU9V0p5EBiBDz8bU1rpFR/kOIkrY8w
    DgYDVR0PAQH/BAQDAgbAMA0GCSqGSIb3DQEBCwUAA4IBAQAszpbiHxzm3F7RRoXM
    4ov0UDkzzorsNDmoC6Qv7QI34nCTZXDBUnx9JINAy03TzxjXXtedNmMNRpzU90wY
    pler0z4Xo+/6QWlkiod0iCkd/HYk3WPspoqYSDiVGDc8N1tMrYUSyeZ9xG2g08i+
    wgGFsgVg8ImPiJElRcEx3Z1z5w8Pypwsga65/6/u/wlSXSnBNXM2CjT0rtDDNWKj
    r6XIk7xSM4aFuLaUTfeSPvC1ezy3hza+Rw57PTdDpwdloAAkzH/N8uisYesLjjTH
    RVSRkXiS3Jth0O77j1L9uRS1eUy8j2dEqdo0jGdpJpgR1OGFEQYLCcLYoWopqQb7
    N112
    -----END CERTIFICATE-----
    """
    
    override func setUpWithError() throws {
        // Plain Data which should be signed
        let sampleData = self._sampleDocument.data(using:.utf8)!
        
        // Load Certificate
        let x509Certificate = try loadPemCertificate()
        
        // Define a Signed data
        self._signedData = SignedData(version: CmsVersion.v3, explicit: true)
        
        // Define the Digest Algorithms included in Signed Data
        self._signedData.addDigestAlgorithm(digestAlgorithmId:DigestAlgorithmId.sha256)
        
        // Define Encapsulated Content Info of Signed Data
        self._signedData.setEncapsulatedContentInfo(content: sampleData)
        
        // Set certificate
        self._signedData.addCertificate(x509Certificate: x509Certificate)
        
        // Define Signer Infos included in Signed Data
        let signerInfo = SignerInfo(version: CmsVersion.v1, x509Certificate: x509Certificate)
        signerInfo.digestAlgorithm = DigestAlgorithmId.sha256
        signerInfo.signatureAlgorithm = SignatureAlgorithmId.sha256_ecdsa
        let hash = SHA256.hash(data: sampleData).compactMap{ String(format: "%02x", $0) }.joined()
        signerInfo.initSignedAttributes(signingTime: Date(timeIntervalSince1970: 1631942076),
                                        digestAlgorithmId: DigestAlgorithmId.sha256,
                                        signatureAlgorithmId: SignatureAlgorithmId.sha256_ecdsa,
                                        digestedData: hash)
        
        print("Signed Attributes : ", signerInfo.signedAttributes.serialize().hexString())
        
        // Signature of plain data
        let signatureData = Data(base64Encoded: self._sampleSignature)
        signerInfo.signature = signatureData!
      
        self._signedData.addSignerInfo(signerInfo: signerInfo)
        
        self._cms = ContentInfo(contentType: Oid.SignedData)
        self._cms._content = (_signedData!)
    }
        
    func loadPemCertificate() throws -> X509Certificate {
        let certificateData = samplePEMcertificate.data(using: .utf8)!
        return try X509Certificate(data: certificateData)
    }
        
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContentType() throws {
        let encodedData = try! self._cms.asn1encode(tag: nil).serialize()
        print("CMS Data Base64 : ", encodedData.base64EncodedString())
        XCTAssertTrue(encodedData.base64EncodedString() == "MIIFSQYJKoZIhvcNAQcCoIIFOjCCBTYCAQMxDTALBglghkgBZQMEAgEwPwYJKoZIhvcNAQcBoDIEMDA5MTI4ODk0NTU4OkM0NjMyMTNDLTMzMzItNEYzMS1CRTVCLTg2RUI1MTk2MUE5M6CCAxQwggMQMIIB+qADAgECAggT4n0/xKX71TALBgkqhkiG9w0BAQswgakxCzAJBgNVBAYTAklSMQ8wDQYDVQQIDAZUZWhyYW4xGTAXBgNVBAoMEE5vbi1Hb3Zlcm5tZW50YWwxEDAOBgNVBAsMB1RlY3Zlc3QxJDAiBgNVBAsMG1NtYXJ0IFRydXN0IEludGVybWVkaWF0ZSBDQTE2MDQGA1UEAwwtU21hcnQgdHJ1c3QgcHJpdmF0ZSBpbnRlcm1lZGlhdGUgYnJvbnplIENBLUczMB4XDTIxMDgwMzE0MTAxN1oXDTIzMDgwMzE0MTAxN1owgaAxCzAJBgNVBAYTAklSMRUwEwYDVQQKDAxVbmFmZmlsaWF0ZWQxFzAVBgNVBAQMDtmF2YrYsdiy2KfYr9mHMRkwFwYDVQQqDBDYs9mK2K/Zhdis2KrYqNmKMRMwEQYDVQQFDAowMDEyMzAwMzA2MRkwFwYDVQQDDBBtb2ppIG1pZXIgW3NpZ25dMRYwFAYJKoZIhvcNAQkBDAdtQG0uY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAElMTNv/EwpspWMZFMVSjRu+P4cpJ+gBoVb841B5+JfQl889wyTmCPHE3dBXDiDvQbhOSRItFHF7ZFV40cBZH2tqMSMBAwDgYDVR0PAQH/BAQDAgbAMAsGCSqGSIb3DQEBCwOCAQEALM6W4h8c5txe0UaFzOKL9FA5M86K7DQ5qAukL+0CN+Jwk2VwwVJ8fSSDQMtN088Y117XnTZjDUac1PdMGKZXq9M+F6Pv+kFpZIqHdIgpHfx2JN1j7KaKmEg4lRg3PDdbTK2FEsnmfcRtoNPIvsIBhbIFYPCJj4iRJUXBMd2dc+cPD8qcLIGuuf+v7v8JUl0pwTVzNgo09K7QwzVio6+lyJO8UjOGhbi2lE33kj7wtXs8t4c2vkcOez03Q6cHZaAAJMx/zfLorGHrC440x0VUkZF4ktybYdDu+49S/bkUtXlMvI9nRKnaNIxnaSaYEdThhREGCwnC2KFqKakG+zdddjGCAccwggHDAgEBMIHEMIG3MQswCQYDVQQGEwJJUjEPMA0GA1UECAwGVGVocmFuMQ8wDQYDVQQHDAZUZWhyYW4xEDAOBgNVBAoMB1RlY3Zlc3QxJDAiBgNVBAsMG1NtYXJ0IFRydXN0IEludGVybWVkaWF0ZSBDQTE2MDQGA1UEAwwtU21hcnQgdHJ1c3QgcHJpdmF0ZSBpbnRlcm1lZGlhdGUgYnJvbnplIENBLUczMRYwFAYJKoZIhvcNAQkBFgdtQG0uY29tAggT4n0/xKX71TALBglghkgBZQMEAgGggZMwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEwOTE4MDUxNDM2WjAoBgkqhkiG9w0BCTQxGzAZMAsGCWCGSAFlAwQCAaEKBggqhkjOPQQDAjAvBgkqhkiG9w0BCQQxIgQgZlAA4NcgPkrvE7IZUNpzJ1EtPyVWtWkYAqQQeuBQWTwwCgYIKoZIzj0EAwIESDBGAiEA7R3BFkpQICVYAstA+9wMu7UuA8h1fI1cUOW81xN/K0ICIQCI0zQ224iPpsHm7EsnlnE3+4+tljgDXmC8vae2wx83UQ==")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}

//extension String {
//  func sliceFrom(start: String, to: String) -> String? {
//    guard let s = rangeOfString(start)?.endIndex else { return nil }
//    guard let e = rangeOfString(to, range: s..<endIndex)?.startIndex else { return nil }
//    return self[s..<e]
//  }
//}
