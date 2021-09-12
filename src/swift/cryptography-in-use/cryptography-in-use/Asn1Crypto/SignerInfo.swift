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
            self._signature = OctetString(data: newValue, tag: nil)
        }
    }
    
    func initSid(x509Certificate: X509Certificate) {
        
        let issuer = x509Certificate.issuerDistinguishedName!
        let issuerDistinguishedNames = issuer.components(separatedBy: ", ")
       
        let subject = x509Certificate.subjectDistinguishedName!
        let subjectDistinguishedNames = subject.components(separatedBy: ", ")
        
        let countryNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CountryName.rawValue),
                                                value: PrintableString(data: issuerDistinguishedNames[0].components(separatedBy: "=").last!))
        let stateOrProvinceNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.StateOrProvinceName.rawValue),
                                                        value: Utf8String(data: issuerDistinguishedNames[1].components(separatedBy: "=").last!))
        let localityNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.LocalityName.rawValue),
                                                 value: Utf8String(data: issuerDistinguishedNames[1].components(separatedBy: "=").last!))
        let organizationNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationName.rawValue),
                                                     value: Utf8String(data: issuerDistinguishedNames[3].components(separatedBy: "=").last!))
        let organizationalUnitNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationalUnitName.rawValue),
                                                           value: Utf8String(data: issuerDistinguishedNames[4].components(separatedBy: "=").last!))
        let commonNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CommonName.rawValue),
                                               value: Utf8String(data: issuerDistinguishedNames[5].components(separatedBy: "=").last!))
        let emailAddressAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.EmailAddress.rawValue),
                                                 value: Ia5String(data: subjectDistinguishedNames[6].components(separatedBy: "=").last!))
        
        let countryName = RelativeDistinguishedName()
        countryName.add(value: countryNameAttribute)
        
        let stateOrProvinceName = RelativeDistinguishedName()
        stateOrProvinceName.add(value: stateOrProvinceNameAttribute)
        
        let localityName = RelativeDistinguishedName()
        localityName.add(value: localityNameAttribute)
        
        let organizationName = RelativeDistinguishedName()
        organizationName.add(value: organizationNameAttribute)
        
        let organizationalUnitName = RelativeDistinguishedName()
        organizationalUnitName.add(value: organizationalUnitNameAttribute)
        
        let commonName = RelativeDistinguishedName()
        commonName.add(value: commonNameAttribute)
        
        let emailAddress = RelativeDistinguishedName()
        emailAddress.add(value: emailAddressAttribute)
        
        let certificateIssuer = RDNSequence()
        certificateIssuer.add(value: countryName)
        certificateIssuer.add(value: stateOrProvinceName)
        certificateIssuer.add(value: localityName)
        certificateIssuer.add(value: organizationName)
        certificateIssuer.add(value: organizationalUnitName)
        certificateIssuer.add(value: commonName)
        certificateIssuer.add(value: emailAddress)
        
        let certificateSerialData : Data = x509Certificate.serialNumber!
        let certificateSerialNumber = Int(bigEndian: certificateSerialData.withUnsafeBytes {$0.load(as: Int.self)})
        
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
        
        self._signedAttributes = SignedAttributes(tag: 0x00)
        self._signedAttributes.add(value: contentTypeAttribute)
        self._signedAttributes.add(value: signingTimeAttribute)
        self._signedAttributes.add(value: cmsAlgorithmProtectionAttribute)
        self._signedAttributes.add(value: messageDigestAttribute)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._version.rawValue, self._sid!, self._digestAlgorithm!, self._signedAttributes, self._signatureAlgorithm!, self._signature]
    }
}
