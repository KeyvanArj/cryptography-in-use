//
//  AttributeValues.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class AttributeValues: AsnSet {
    
    private var _values: [AttributeValue] = []
    
    func add(value : AttributeValue) {
        self._values.append(value)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return self._values
    }
}
