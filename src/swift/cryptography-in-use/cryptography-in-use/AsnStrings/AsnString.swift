//
//  AsnString.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class AsnString : ASN1EncodableType {
    
    private var _data : String
    private var _tag : ASN1DecodedTag
    private var _explicit : Bool
    
    init(data : String, tag: ASN1DecodedTag, explicit: Bool = false) {
        self._data = data
        self._tag = tag
        self._explicit = explicit
    }
    
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let asn1Object = try self._data.asn1encode(tag: self._tag)
        if (self._explicit == false) {
            return asn1Object
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
}
