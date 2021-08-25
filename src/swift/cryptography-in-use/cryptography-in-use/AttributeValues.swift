//
//  AttributeValues.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class AttributeValues: AsnSet {
    
    var _values: [AttributeValue]!
    
    override func getData() -> [ASN1EncodableType] {
        return self._values
    }
}
