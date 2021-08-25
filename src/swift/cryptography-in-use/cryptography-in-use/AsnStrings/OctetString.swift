//
//  OctetString.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class OctetString : ASN1EncodableType {
    
    var binaryData : Data
    var _explicit : Bool
    
    init(data : Data, explicit: Bool = false) {
        self._explicit = explicit
        self.binaryData = data
    }
    
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let asn1Object = ASN1Primitive(data: .primitive(self.binaryData), tag: .universal(.octetString))
        if (self._explicit == false) {
            return asn1Object
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
}
