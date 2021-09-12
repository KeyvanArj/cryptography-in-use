//
//  SignedAttributes.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class SignedAttributes: AsnSet {
    
    private var _attributes : [Attribute] = []
    
    func add(value: Attribute) {
        self._attributes.append(value)
    }
    
    func serialize() -> Data {
        let tag = self._tag
        self._tag = UInt.max
        let data = try! self.asn1encode(tag: nil).serialize()
        self._tag = tag
        return data
    }
    
    override func getData() -> [ASN1EncodableType] {
        return self._attributes
    }
}
