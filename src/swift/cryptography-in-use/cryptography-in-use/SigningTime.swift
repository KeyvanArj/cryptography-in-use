//
//  SigingTime.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class SigningTime : AttributeValue {
    
    private var _value : Date
    
    init(value: Date) {
        self._value = value
    }
        
    override func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        return try self._value.asn1encode(tag: .universal(.utcTime))
    }
}
