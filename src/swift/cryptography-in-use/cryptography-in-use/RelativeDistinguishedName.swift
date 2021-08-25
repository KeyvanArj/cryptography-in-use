//
//  RelativeDistinguishedName.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class RelativeDistinguishedName : AsnSet {
    
    var _attributeTypeAndValue : [AttributeTypeAndValue]!
           
    override func getData() -> [ASN1EncodableType] {
        return self._attributeTypeAndValue
    }
}
