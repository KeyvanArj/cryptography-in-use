//
//  CMSAlgorithmPro.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/2/1400 AP.
//

import Foundation

class CMSAlgorithmProtection: AttributeValue {
    
    private var _value: CMSAlgorithmProtectionValue
    
    init(cmsAlgorithmProtectionValue: CMSAlgorithmProtectionValue) {
        self._value = cmsAlgorithmProtectionValue
    }
    
    override func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        return try! self._value.asn1encode(tag: tag)
    }
}
