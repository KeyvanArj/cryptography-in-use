//
//  TBSCertificate.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class TBSCertificate : AsnSequnce {
    
    private var _version : CertificateVersion!
    private var _serialNumber : Int!
    private var _signatureAlgorithm : SignatureAlgorithmIdentifier!
    private var _issuer : RDNSequence
    private var _validity : Validity!
    private var _subject : RDNSequence
    private var _subjectPublicKeyInfo : SubjectPublicKeyInfo
    private var _extensions : CertificateExtensions
    
    
    init() {
        self._extensions = CertificateExtensions(explicit: true, tag: 3)
        self._subjectPublicKeyInfo = SubjectPublicKeyInfo()
        self._issuer = RDNSequence()
        self._subject = RDNSequence()
    }
    
    func load(x509Certificate : X509Certificate) {
        self._version = CertificateVersion(explicit: true, value: x509Certificate.version!)
        self._serialNumber = Int(bigEndian: x509Certificate.serialNumber!.withUnsafeBytes {$0.load(as: Int.self)})
        self._signatureAlgorithm = SignatureAlgorithmIdentifier(algorithm: (x509Certificate.sigAlgOID)!)
        self._subjectPublicKeyInfo.load(publicKey: x509Certificate.publicKey!)
        self._validity = Validity(notBefore: (x509Certificate.notBefore)!, notAfter: (x509Certificate.notAfter)!)
        self._extensions.loadFrom(x509Certificate: x509Certificate)
        self.loadSubject(distinguishedName: x509Certificate.subjectDistinguishedName!)
        self.loadIssuer(distinguishedName: x509Certificate.issuerDistinguishedName!)
    }
    
    func loadSubject(distinguishedName: String) {
      
        let distinguishedNames = distinguishedName.components(separatedBy: ", ")
        
        let countryNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CountryName.rawValue),
                                                       value: PrintableString(data: distinguishedNames[0].components(separatedBy: "=").last!))
        let organizationNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationName.rawValue),
                                                            value: Utf8String(data: distinguishedNames[1].components(separatedBy: "=").last!))
        let surNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.SurName.rawValue),
                                                   value: Utf8String(data: distinguishedNames[2].components(separatedBy: "=").last!))
        let givenNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.GivenName.rawValue),
                                                     value: Utf8String(data: distinguishedNames[3].components(separatedBy: "=").last!))
        let serialNumberAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.SerialNumber.rawValue),
                                                        value: Utf8String(data: distinguishedNames[4].components(separatedBy: "=").last!))
        let commonNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CommonName.rawValue),
                                                      value: Utf8String(data: distinguishedNames[5].components(separatedBy: "=").last!))
        let emailAddressAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.EmailAddress.rawValue),
                                                    value: Utf8String(data: distinguishedNames[6].components(separatedBy: "=").last!))
        
        let countryName = RelativeDistinguishedName()
        countryName.add(value: countryNameAttribute)
        
        let organizationName = RelativeDistinguishedName()
        organizationName.add(value: organizationNameAttribute)
        
        let surName = RelativeDistinguishedName()
        surName.add(value: surNameAttribute)
        
        let givenName = RelativeDistinguishedName()
        givenName.add(value: givenNameAttribute)
        
        let serialNumber = RelativeDistinguishedName()
        serialNumber.add(value: serialNumberAttribute)
        
        let commonName = RelativeDistinguishedName()
        commonName.add(value: commonNameAttribute)
        
        let emailAddress = RelativeDistinguishedName()
        emailAddress.add(value: emailAddressAttribute)
        
        self._subject.add(value: countryName)
        self._subject.add(value: organizationName)
        self._subject.add(value: surName)
        self._subject.add(value: givenName)
        self._subject.add(value: serialNumber)
        self._subject.add(value: commonName)
        self._subject.add(value: emailAddress)
    }
    
    func loadIssuer(distinguishedName: String) {
        
        let distinguishedNames = distinguishedName.components(separatedBy: ", ")
        
        let countryNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CountryName.rawValue),
                                                         value: PrintableString(data: distinguishedNames[0].components(separatedBy: "=").last!))
        
        let stateOrProvinceNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.StateOrProvinceName.rawValue),
                                                                 value: Utf8String(data: distinguishedNames[1].components(separatedBy: "=").last!))
        
        let organizationNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationName.rawValue),
                                                              value: Utf8String(data: distinguishedNames[2].components(separatedBy: "=").last!))
        
        let organizationalUnitName1Attribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationalUnitName.rawValue),
                                                                     value: Utf8String(data: distinguishedNames[3].components(separatedBy: "=").last!))
        
        let organizationalUnitName2Attribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationalUnitName.rawValue),
                                                                     value: Utf8String(data: distinguishedNames[4].components(separatedBy: "=").last!))
        
        let commonNameAttribute = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CommonName.rawValue),
                                                        value: Utf8String(data: distinguishedNames[5].components(separatedBy: "=").last!))
        
        let countryName = RelativeDistinguishedName()
        countryName.add(value: countryNameAttribute)
        
        let stateOrProvinceName = RelativeDistinguishedName()
        stateOrProvinceName.add(value: stateOrProvinceNameAttribute)
        
        let organizationName = RelativeDistinguishedName()
        organizationName.add(value: organizationNameAttribute)
        
        let organizationalUnitName1 = RelativeDistinguishedName()
        organizationalUnitName1.add(value: organizationalUnitName1Attribute)
        
        let organizationalUnitName2 = RelativeDistinguishedName()
        organizationalUnitName2.add(value: organizationalUnitName2Attribute)
        
        let commonName = RelativeDistinguishedName()
        commonName.add(value: commonNameAttribute)
        
        self._issuer.add(value: countryName)
        self._issuer.add(value: stateOrProvinceName)
        self._issuer.add(value: organizationName)
        self._issuer.add(value: organizationalUnitName1)
        self._issuer.add(value: organizationalUnitName2)
        self._issuer.add(value: commonName)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._version, self._serialNumber, self._signatureAlgorithm, self._issuer, self._validity, self._subject, self._subjectPublicKeyInfo, self._extensions]
    }
    
}
