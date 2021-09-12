//
//  Attribute.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class Attribute: AsnSequnce {
    
    private var _attrType: ObjectIdentifier!
    private var _attrValues: AttributeValues!
    
    init(attrType: ObjectIdentifier, attrValues: AttributeValues) {
        self._attrType = attrType
        self._attrValues = attrValues
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._attrType, self._attrValues]
    }
    
}
