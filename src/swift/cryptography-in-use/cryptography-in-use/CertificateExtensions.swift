//
//  CertificateExtensions.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class CertificateExtensions : AsnSequnce {
    
    private var _keyUsage : KeyUsageExtension!
    private var _subjectKeyIdentifier : SubjectKeyIdentifierExtension!
    private var _extendedKeyUsage : ExtendedKeyUsageExtension!
    private var _authorityKeyIdentifier : AuthorityKeyIdentifierExtension!
    
    func loadFrom(x509Certificate : X509Certificate) {
        self._keyUsage = KeyUsageExtension(value: x509Certificate.keyUsage)
        self._subjectKeyIdentifier = SubjectKeyIdentifierExtension(value: x509Certificate.extensionObject(oid: OID.subjectKeyIdentifier)?.value as! Data)
        self._extendedKeyUsage = ExtendedKeyUsageExtension(value: x509Certificate.extendedKeyUsage)
        self._authorityKeyIdentifier = AuthorityKeyIdentifierExtension(value: x509Certificate.extensionObject(oid: OID.authorityKeyIdentifier)?.value as! Data)
    }
    
    override func getData() -> [ASN1EncodableType]! {
        return [_keyUsage, _extendedKeyUsage, _subjectKeyIdentifier, _authorityKeyIdentifier]
    }
}
