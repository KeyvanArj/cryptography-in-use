//
//  CMSAlgorithmProtectionValue.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/2/1400 AP.
//

import Foundation

class CMSAlgorithmProtectionValue: AsnSequnce {
    
    private var _digestAlgorithm: DigestAlgorithmIdentifier!
    private var _signatureAlgorithm: SignatureAlgorithmIdentifier!
    
    init(digestAlgorithm: DigestAlgorithmIdentifier, signatureAlgorithm: SignatureAlgorithmIdentifier) {
        self._digestAlgorithm = digestAlgorithm
        self._signatureAlgorithm = signatureAlgorithm
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._digestAlgorithm, self._signatureAlgorithm]
    }
    
}
