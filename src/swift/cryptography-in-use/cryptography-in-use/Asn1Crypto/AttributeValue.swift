//
//  AttributeValue.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class AttributeValue: ASN1EncodableType {

    private var _explicit: Bool!
    
    init(explicit: Bool = false) {
        self._explicit = explicit
    }
    
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let nullValue = Data([0x00])
        return ASN1Primitive(data: .primitive(nullValue), tag: .universal(.integer))
    }
}
