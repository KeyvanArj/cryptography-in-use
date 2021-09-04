//
//  MessageDigest.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class MessageDigest : AttributeValue {
    
    private var _value : String
    
    init(hexString: String) {
        self._value = hexString
    }
        
    override func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let data = self._value.hexaData
        let digest = OctetString(data: data, tag: nil)
        return try digest.asn1encode(tag: tag)
    }
}
