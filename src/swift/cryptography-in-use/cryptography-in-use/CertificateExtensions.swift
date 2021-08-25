//
//  CertificateExtensions.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class CertificateExtensions : AsnSequnce {
    
    private var _keyUsage : KeyUsageExtension!
    
    func loadFrom(x509Certificate : X509Certificate) {
        self._keyUsage = KeyUsageExtension(value: x509Certificate.keyUsage)
    }
    
    override func getData() -> [ASN1EncodableType]! {
        return [_keyUsage]
    }
}
