//
//  CertificateTest.swift
//  cryptography-in-useTests
//
//  Created by Mojtaba Mirzadeh on 5/21/1400 AP.
//

import XCTest
@testable import cryptography_in_use

class CertificateTest: XCTestCase {

    var x509Certificate : X509Certificate!
    
    let pemCertificate = """
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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.x509Certificate = try getCertificate()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func getCertificate() throws -> X509Certificate {
        let certificateData = pemCertificate.data(using: .utf8)!
        return try X509Certificate(data: certificateData)
    }
        
    func testCertificateEncoding() throws {
        let x509Certificate = try! getCertificate()
        
        let asn1Certificate = Certificate()
        asn1Certificate.loadCertificate(x509Certificate: x509Certificate)
        let encodedData = try asn1Certificate.asn1encode(tag: nil).serialize().base64EncodedString()
        print("Encoded Certificate : ", encodedData)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
