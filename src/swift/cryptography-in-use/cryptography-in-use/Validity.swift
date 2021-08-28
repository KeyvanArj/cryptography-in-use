//
//  Validity.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class Validity: AsnSequnce {
    
    private var _notBefore : Date
    private var _notAfter : Date
    
    init(notBefore: Date, notAfter: Date) {
        self._notBefore = notBefore
        self._notAfter = notAfter
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._notBefore, self._notAfter]
    }
    
    override func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        return try super.asn1encode(tag: .universal(.utcTime))
    }
    
}
