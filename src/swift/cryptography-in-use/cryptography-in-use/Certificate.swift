//
//  Certificate.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class Certificate : AsnSequnce {
    
    private var _tbsCertificate : TBSCertificate!
    private var _signatureAlgorithm : SignatureAlgorithmIdentifier!
    private var _signatureValue : BitString!
    
    init(explicit : Bool = false) {
        super.init(explicit: explicit)
    }
    
    func loadCertificate(x509Certificate: X509Certificate) {
        let issuerDistinguishedName    = x509Certificate.issuerDistinguishedName!
        let issuerDistinguishedNameArr = issuerDistinguishedName.components(separatedBy: ", ")
        
        let subjectDistinguishedName = x509Certificate.subjectDistinguishedName!
        let subjectDistinguishedNameArr = subjectDistinguishedName.components(separatedBy: ", ")
        
        let certificateSerialData : Data = x509Certificate.serialNumber!
        let certificateSerialNumber = Int(bigEndian: certificateSerialData.withUnsafeBytes {$0.load(as: Int.self)})
        
        
        let publicKeyParameters : String = (x509Certificate.publicKey?.algParams)!
        let publicKeyAlgorithm = SignatureAlgorithmIdentifier(algorithm: (x509Certificate.publicKey?.algOid)!,
                                                              parameter: publicKeyParameters)
        let publicKeyBytes = x509Certificate.publicKey?.key
        let publicKey = BitString(data: publicKeyBytes!)
        let certificateSignature = BitString(data: (x509Certificate.signature)!)
        
        // MARK: - issuer
        let issuerCountryName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CountryName.rawValue), value: PrintableString(data: issuerDistinguishedNameArr[0].components(separatedBy: "=").last!))
        let issuerStateOrProvinceName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.StateOrProvinceName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[1].components(separatedBy: "=").last!))
        let issuerOrganizationName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[2].components(separatedBy: "=").last!))
        let issuerOrganizationalUnitName1 = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationalUnitName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[3].components(separatedBy: "=").last!))
        let issuerOrganizationalUnitName2 = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationalUnitName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[4].components(separatedBy: "=").last!))
        let issuerCommonName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CommonName.rawValue), value: Utf8String(data: issuerDistinguishedNameArr[5].components(separatedBy: "=").last!))
        
        let issuerRdnCountryName = RelativeDistinguishedName()
        issuerRdnCountryName._attributeTypeAndValue = [issuerCountryName]
        
        let issuerRdnStateOrProvinceName = RelativeDistinguishedName()
        issuerRdnStateOrProvinceName._attributeTypeAndValue = [issuerStateOrProvinceName]
        
        let issuerRdnOrganizationName = RelativeDistinguishedName()
        issuerRdnOrganizationName._attributeTypeAndValue = [issuerOrganizationName]
        
        let issuerRdnOrganizationalUnitName1 = RelativeDistinguishedName()
        issuerRdnOrganizationalUnitName1._attributeTypeAndValue = [issuerOrganizationalUnitName1]
        
        let issuerRdnOrganizationalUnitName2 = RelativeDistinguishedName()
        issuerRdnOrganizationalUnitName2._attributeTypeAndValue = [issuerOrganizationalUnitName2]
        
        let issuerRdnCommonName = RelativeDistinguishedName()
        issuerRdnCommonName._attributeTypeAndValue = [issuerCommonName]
        
        let certificateIssuer = RDNSequence()
        certificateIssuer._relativeDistinguishedName = [issuerRdnCountryName, issuerRdnStateOrProvinceName, issuerRdnOrganizationName, issuerRdnOrganizationalUnitName1, issuerRdnOrganizationalUnitName2, issuerRdnCommonName]
        
        // MARK: - subject
        let subjectCountryName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CountryName.rawValue), value: PrintableString(data: subjectDistinguishedNameArr[0].components(separatedBy: "=").last!))
        let subjectOrganizationName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.OrganizationName.rawValue), value: Utf8String(data: subjectDistinguishedNameArr[1].components(separatedBy: "=").last!))
        let subjectSurName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.SurName.rawValue), value: Utf8String(data: subjectDistinguishedNameArr[2].components(separatedBy: "=").last!))
        let subjectGivenName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.GivenName.rawValue), value: Utf8String(data: subjectDistinguishedNameArr[3].components(separatedBy: "=").last!))
        let subjectSerialNumber = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.SerialNumber.rawValue), value: Utf8String(data: subjectDistinguishedNameArr[4].components(separatedBy: "=").last!))
        let subjectCommonName = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.CommonName.rawValue), value: Utf8String(data: subjectDistinguishedNameArr[5].components(separatedBy: "=").last!))
        let subjectEmailAdd = AttributeTypeAndValue(type: try! ObjectIdentifier.from(string: Oid.EmailAddress.rawValue), value: Utf8String(data: subjectDistinguishedNameArr[6].components(separatedBy: "=").last!))
        
        let subjectRdnCountryName = RelativeDistinguishedName()
        subjectRdnCountryName._attributeTypeAndValue = [subjectCountryName]
        
        let subjectRdnOrganizationName = RelativeDistinguishedName()
        subjectRdnOrganizationName._attributeTypeAndValue = [subjectOrganizationName]
        
        let subjectRdnSurName = RelativeDistinguishedName()
        subjectRdnSurName._attributeTypeAndValue = [subjectSurName]
        
        let subjectRdnGivenName = RelativeDistinguishedName()
        subjectRdnGivenName._attributeTypeAndValue = [subjectGivenName]
        
        let subjectRdnSerialNumber = RelativeDistinguishedName()
        subjectRdnSerialNumber._attributeTypeAndValue = [subjectSerialNumber]
        
        let subjectRdnCommonName = RelativeDistinguishedName()
        subjectRdnCommonName._attributeTypeAndValue = [subjectCommonName]
        
        let subjectRdnEmailAdd = RelativeDistinguishedName()
        subjectRdnEmailAdd._attributeTypeAndValue = [subjectEmailAdd]
        
        let certificateSubject = RDNSequence()
        certificateSubject._relativeDistinguishedName = [subjectRdnCountryName, subjectRdnOrganizationName, subjectRdnSurName, subjectRdnGivenName, subjectRdnSerialNumber, subjectRdnCommonName, subjectRdnEmailAdd]
        
        let signatureAlgorithm = SignatureAlgorithmIdentifier(algorithm: (x509Certificate.sigAlgOID)!)
        let validity = Validity(notBefore: (x509Certificate.notBefore)!, notAfter: (x509Certificate.notAfter)!)
        let subjectPublicKeyInfo = SubjectPublicKeyInfo(algotithm: publicKeyAlgorithm, publicKey: publicKey)
        let version = CertificateVersion(explicit: true, value: CertificateVersionMap.v3)
        let extensions = CertificateExtensions(explicit: true, tag: 3)
        extensions.loadFrom(x509Certificate: x509Certificate)
        let tbsCertificate  = TBSCertificate(version: version,
                                             serialNum: certificateSerialNumber,
                                             signatureAlgorithm: signatureAlgorithm,
                                             issuer: certificateIssuer,
                                             validity: validity,
                                             subject: certificateSubject,
                                             publicKeyInfo: subjectPublicKeyInfo,
                                             extensions: extensions)
        
        self._tbsCertificate = tbsCertificate
        self._signatureAlgorithm = signatureAlgorithm
        self._signatureValue = certificateSignature
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._tbsCertificate, self._signatureAlgorithm, self._signatureValue]
    }
}
