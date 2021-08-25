//
//  TBSCertificate.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class TBSCertificate : AsnSequnce {
    
    var _version : CertificateVersion
    var _serialNumber : Int
    var _signatureAlgorithm : SignatureAlgorithmIdentifier
    var _issuer : RDNSequence
    var _validity : Validity
    var _subject : RDNSequence
    var _subjectPublicKeyInfo : SubjectPublicKeyInfo
    var _extensions : CertificateExtensions!
    
    
    init(version: CertificateVersion,
         serialNum: Int,
         signatureAlgorithm: SignatureAlgorithmIdentifier,
         issuer: RDNSequence,
         validity: Validity,
         subject: RDNSequence,
         publicKeyInfo: SubjectPublicKeyInfo,
         extensions: CertificateExtensions) {
        self._version = version
        self._serialNumber = serialNum
        self._signatureAlgorithm = signatureAlgorithm
        self._issuer = issuer
        self._validity = validity
        self._subject = subject
        self._subjectPublicKeyInfo = publicKeyInfo
        self._extensions = extensions
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._version, self._serialNumber, self._signatureAlgorithm, self._issuer, self._validity, self._subject, self._subjectPublicKeyInfo, self._extensions]
    }
    
}
