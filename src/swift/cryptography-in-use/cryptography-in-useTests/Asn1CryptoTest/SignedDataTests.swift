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
    var _sampleData : Data!
    var _x509Certificate : X509Certificate!
    
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
        
        // Convert the sample text data to array of bytes
        self._sampleData = self._sampleDocument.data(using:.utf8)!
        
        // Load Certificate
        self._x509Certificate = try loadPemCertificate()
    }
        
    func loadPemCertificate() throws -> X509Certificate {
        let certificateData = samplePEMcertificate.data(using: .utf8)!
        return try X509Certificate(data: certificateData)
    }
    
    func testSignedDataEncoding() throws {
        
        // Define a Signed data
        let signedData = SignedData(version: CmsVersion.v3, explicit: true)
        
        // Define the Digest Algorithms included in Signed Data
        signedData.addDigestAlgorithm(digestAlgorithmId:DigestAlgorithmId.sha256)
        
        // Define Encapsulated Content Info of Signed Data
        signedData.setEncapsulatedContentInfo(content: self._sampleData)
        
        // Set certificate
        signedData.addCertificate(x509Certificate: self._x509Certificate)
        
        // Define Signer Infos included in Signed Data
        let signerInfo = SignerInfo(version: CmsVersion.v1, x509Certificate: self._x509Certificate)
        signerInfo.digestAlgorithm = DigestAlgorithmId.sha256
        signerInfo.signatureAlgorithm = SignatureAlgorithmId.sha256_ecdsa
        let hash = SHA256.hash(data: self._sampleData).compactMap{ String(format: "%02x", $0) }.joined()
        signerInfo.initSignedAttributes(signingTime: Date(timeIntervalSince1970: 1631942076),
                                        digestAlgorithmId: DigestAlgorithmId.sha256,
                                        signatureAlgorithmId: SignatureAlgorithmId.sha256_ecdsa,
                                        digestedData: hash)
        
        // Signed Attributes should be set as the input of Digital Signature process
        print("Signed Attributes : ", signerInfo.signedAttributes.serialize().hexString())
        
        // Signature of plain data
        let signatureData = Data(base64Encoded: self._sampleSignature)
        signerInfo.signature = signatureData!
      
        signedData.addSignerInfo(signerInfo: signerInfo)
        
        let cms = ContentInfo(contentType: Oid.SignedData)
        cms.content = (signedData)
        
        let encodedData = try! cms.asn1encode(tag: nil).serialize()
        print("CMS Data Base64 : ", encodedData.base64EncodedString())
        XCTAssertTrue(encodedData.base64EncodedString() == "MIIFngYJKoZIhvcNAQcCoIIFjzCCBYsCAQMxDTALBglghkgBZQMEAgEwPwYJKoZIhvcNAQcBoDIEMDA5MTI4ODk0NTU4OkM0NjMyMTNDLTMzMzItNEYzMS1CRTVCLTg2RUI1MTk2MUE5M6CCA2kwggNlMIICT6ADAgEDAggT4n0/xKX71TALBgkqhkiG9w0BAQswgakxCzAJBgNVBAYTAklSMQ8wDQYDVQQIDAZUZWhyYW4xGTAXBgNVBAoMEE5vbi1Hb3Zlcm5tZW50YWwxEDAOBgNVBAsMB1RlY3Zlc3QxJDAiBgNVBAsMG1NtYXJ0IFRydXN0IEludGVybWVkaWF0ZSBDQTE2MDQGA1UEAwwtU21hcnQgdHJ1c3QgcHJpdmF0ZSBpbnRlcm1lZGlhdGUgYnJvbnplIENBLUczMB4XDTIxMDgwMzE0MTAxN1oXDTIzMDgwMzE0MTAxN1owgaAxCzAJBgNVBAYTAklSMRUwEwYDVQQKDAxVbmFmZmlsaWF0ZWQxFzAVBgNVBAQMDtmF2YrYsdiy2KfYr9mHMRkwFwYDVQQqDBDYs9mK2K/Zhdis2KrYqNmKMRMwEQYDVQQFDAowMDEyMzAwMzA2MRkwFwYDVQQDDBBtb2ppIG1pZXIgW3NpZ25dMRYwFAYJKoZIhvcNAQkBDAdtQG0uY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAElMTNv/EwpspWMZFMVSjRu+P4cpJ+gBoVb841B5+JfQl889wyTmCPHE3dBXDiDvQbhOSRItFHF7ZFV40cBZH2tqNnMGUwDgYDVR0PAQH/BAQDAgbAMBMGA1UdJQQMMAoGCCsGAQUFBwMCMB0GA1UdDgQWBBT1XSnkQGIEPPxtTWukVH+Q4iStjzAfBgNVHSMEGDAWgBRDwd9C6fm8XNACZe/h7uaPes/CezALBgkqhkiG9w0BAQsDggEBACzOluIfHObcXtFGhczii/RQOTPOiuw0OagLpC/tAjficJNlcMFSfH0kg0DLTdPPGNde1502Yw1GnNT3TBimV6vTPhej7/pBaWSKh3SIKR38diTdY+ymiphIOJUYNzw3W0ythRLJ5n3EbaDTyL7CAYWyBWDwiY+IkSVFwTHdnXPnDw/KnCyBrrn/r+7/CVJdKcE1czYKNPSu0MM1YqOvpciTvFIzhoW4tpRN95I+8LV7PLeHNr5HDns9N0OnB2WgACTMf83y6Kxh6wuONMdFVJGReJLcm2HQ7vuPUv25FLV5TLyPZ0Sp2jSMZ2kmmBHU4YURBgsJwtihaimpBvs3XXYxggHHMIIBwwIBATCBxDCBtzELMAkGA1UEBhMCSVIxDzANBgNVBAgMBlRlaHJhbjEPMA0GA1UEBwwGVGVocmFuMRAwDgYDVQQKDAdUZWN2ZXN0MSQwIgYDVQQLDBtTbWFydCBUcnVzdCBJbnRlcm1lZGlhdGUgQ0ExNjA0BgNVBAMMLVNtYXJ0IHRydXN0IHByaXZhdGUgaW50ZXJtZWRpYXRlIGJyb256ZSBDQS1HMzEWMBQGCSqGSIb3DQEJARYHbUBtLmNvbQIIE+J9P8Sl+9UwCwYJYIZIAWUDBAIBoIGTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkxODA1MTQzNlowKAYJKoZIhvcNAQk0MRswGTALBglghkgBZQMEAgGhCgYIKoZIzj0EAwIwLwYJKoZIhvcNAQkEMSIEIGZQAODXID5K7xOyGVDacydRLT8lVrVpGAKkEHrgUFk8MAoGCCqGSM49BAMCBEgwRgIhAO0dwRZKUCAlWALLQPvcDLu1LgPIdXyNXFDlvNcTfytCAiEAiNM0NtuIj6bB5uxLJ5ZxN/uPrZY4A15gvL2ntsMfN1E=")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        // Plain Data which should be signed
       
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
