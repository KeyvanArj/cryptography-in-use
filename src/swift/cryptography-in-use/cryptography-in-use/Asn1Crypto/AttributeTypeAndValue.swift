//
//  AttributeTypeAndValue.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class AttributeTypeAndValue : AsnSequnce {

    private var _attributeType : ObjectIdentifier
    private var _attributeValue : AsnString
    
    init(type: ObjectIdentifier, value: AsnString) {
        self._attributeType = type
        self._attributeValue = value
    }
    override func getData() -> [ASN1EncodableType] {
        return [self._attributeType, self._attributeValue]
    }
}
