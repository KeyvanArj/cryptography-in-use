//
//  RelativeDistinguishedName.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class RelativeDistinguishedName : AsnSet {
    
    private var _values : [AttributeTypeAndValue] = []
    
    func add(value: AttributeTypeAndValue) {
        self._values.append(value)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return self._values
    }
}
