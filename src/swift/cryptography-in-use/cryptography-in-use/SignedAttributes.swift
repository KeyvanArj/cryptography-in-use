//
//  SignedAttributes.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/31/1400 AP.
//

import Foundation

class SignedAttributes: AsnSet {
    
    var _attributes : [Attribute]!
    
    func serialize() -> Data {
        let implicitTag = self._implicitTag
        self._implicitTag = UInt.max
        let data = try! self.asn1encode(tag: nil).serialize()
        self._implicitTag = implicitTag
        return data
    }
    override func getData() -> [ASN1EncodableType] {
        return self._attributes
    }
}
