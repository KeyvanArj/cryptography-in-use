//
//  ContentType.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class ContentType : AttributeValue {
    
    private var _value : ObjectIdentifier!
    
    init(value: String) {
        self._value = try! ObjectIdentifier.from(string: value)
    }
    
    override func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        return try! self._value.asn1encode(tag: tag)
    }
}
