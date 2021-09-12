//
//  OctetString.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class OctetString : ASN1EncodableType {
    
    private var _binaryData : Data
    private var _explicit : Bool
    private var _tag : ASN1DecodedTag!
    
    init(data : Data, explicit: Bool = false, tag: ASN1DecodedTag?) {
        self._explicit = explicit
        self._binaryData = data
        self._tag = tag
    }
    
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let asn1Object = ASN1Primitive(data: .primitive(self._binaryData), tag: self._tag ?? .universal(.octetString))
        if (self._explicit == false) {
            return asn1Object
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
}
