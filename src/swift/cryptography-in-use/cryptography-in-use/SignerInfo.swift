//
//  SignerInfo.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class SignerInfo : AsnSequnce {
    
    private var _version : CmsVersion!
    private var _sid : IssuerAndSerialNumber!
    private var _digestAlgorithm : DigestAlgorithmIdentifier!
    private var _signedAttributes : SignedAttributes!
    private var _signatureAlgorithm : SignatureAlgorithmIdentifier!
    private var _signature : OctetString!
    
    init(version: CmsVersion, x509Certificate: X509Certificate) {
        super.init()
        self._version = version
        self.initSid(x509Certificate: x509Certificate)
    }
    
    var digestAlgorithm : DigestAlgorithmId? {
        willSet {
            self._digestAlgorithm = DigestAlgorithmIdentifier(algorithm: newValue!)
        }
    }
    
    var signatureAlgorithm : SignatureAlgorithmId? {
        willSet {
            self._signatureAlgorithm = SignatureAlgorithmIdentifier(algorithm: (newValue?.rawValue)!)
        }
    }
    
    var signedAttributes : SignedAttributes {
        get {
            return self._signedAttributes
        }
    }
    
    var signature : Data {
        get {
            return try! self._signature.asn1encode(tag: nil).serialize()
        }
        set {
            self._signature = OctetString(data: newValue)
        }
    }
    
    func initSid(x509Certificate: X509Certificate) {
        let issuerDistinguishedName    = x509Certificate.issuerDistinguishedName!
        let issuerDistinguishedNameArr = issuerDistinguishedName.components(separatedBy: ", ")
        let subjectDistinguishedName = x509Certificate.subjectDistinguishedName!
        let subjectDistinguishedNameArr = subjectDistinguishedName.components(separatedBy: ", ")
        let certificateSerialData : Data = x509Certificate.serialNumber!
        let certificateSerialNumber = Int(bigEndian: certificateSerialData.withUnsafeBytes {$0.load(as: Int.self)})
        
        let certificateIssuer = RDNSequence()
        
        let countryName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CountryName.rawValue), value: PrintableString(data: issuerDistinguishedNameArr[0].components(separatedBy: "=").last!))
        let stateOrProvinceName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.StateOrProvinceName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[1].components(separatedBy: "=").last!))
        let localityName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.LocalityName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[1].components(separatedBy: "=").last!))
        let organizationName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[3].components(separatedBy: "=").last!))
        let organizationalUnitName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationalUnitName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[4].components(separatedBy: "=").last!))
        let commonName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CommonName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[5].components(separatedBy: "=").last!))
        let emailAddress = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.EmailAddress.rawValue), value: Ia5String(data: subjectDistinguishedNameArr[6].components(separatedBy: "=").last!))
        
        let rdnCountryName = RelativeDistinguishedName()
        rdnCountryName._attributeTypeAndValue = [countryName]
        
        let rdnStateOrProvinceName = RelativeDistinguishedName()
        rdnStateOrProvinceName._attributeTypeAndValue = [stateOrProvinceName]
        
        let rdnLocalityName = RelativeDistinguishedName()
        rdnLocalityName._attributeTypeAndValue = [localityName]
        
        let rdnOrganizationName = RelativeDistinguishedName()
        rdnOrganizationName._attributeTypeAndValue = [organizationName]
        
        let rdnOrganizationalUnitName = RelativeDistinguishedName()
        rdnOrganizationalUnitName._attributeTypeAndValue = [organizationalUnitName]
        
        let rdnCommonName = RelativeDistinguishedName()
        rdnCommonName._attributeTypeAndValue = [commonName]
        
        let rdnEmailAddress = RelativeDistinguishedName()
        rdnEmailAddress._attributeTypeAndValue = [emailAddress]
        
        certificateIssuer._relativeDistinguishedName = [rdnCountryName, rdnStateOrProvinceName, rdnLocalityName, rdnOrganizationName, rdnOrganizationalUnitName, rdnCommonName, rdnEmailAddress]
        
        self._sid = IssuerAndSerialNumber(issuer: certificateIssuer, serial: certificateSerialNumber)
        
    }
    
    func initSignedAttributes(signingTime: Date,
                              digestAlgorithmId: DigestAlgorithmId,
                              signatureAlgorithmId: SignatureAlgorithmId,
                              digestedData: String) {
        // Content Type
        let contentTypeAttribute = ContentTypeAttribute(value: OID.pkcs7data.rawValue)
        
        // Signing Time
        let signingTimeAttribute = SigningTimeAttribute(value: signingTime)
        
        // CMS Algorithm Protection
        let cmsAlgorithmProtectionAttribute = CMSAlgorithmProtectionAttribute(digestAlgorithmId: digestAlgorithmId,
                                                                              signatureAlgorithmId: signatureAlgorithmId)
        
        //MessageDigest
        let messageDigestAttribute = MessageDigestAttribute(value: digestedData)
        
        self._signedAttributes = SignedAttributes(implicitTag: 0x00)
        self._signedAttributes._attributes = [contentTypeAttribute,
                                              signingTimeAttribute,
                                              cmsAlgorithmProtectionAttribute,
                                              messageDigestAttribute]
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._version.rawValue, self._sid!, self._digestAlgorithm!, self._signedAttributes, self._signatureAlgorithm!, self._signature]
    }
}
