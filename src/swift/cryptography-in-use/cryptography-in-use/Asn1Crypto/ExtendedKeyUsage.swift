//
//  ExtendedKeyUsage.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/6/1400 AP.
//

import Foundation

class ExtendedKeyUsage : AsnSequnce {
    
    private var _values : [ObjectIdentifier] = []
    
    init(explicit: Bool = false, tag: UInt = UInt.max, values: [String]) {
        super.init(explicit: explicit, tag: tag)
        for item in values {
            self._values.append(try! ObjectIdentifier.from(string: item))
        }
    }
    
    override func getData() -> [ASN1EncodableType]! {
        return self._values
    }
}
