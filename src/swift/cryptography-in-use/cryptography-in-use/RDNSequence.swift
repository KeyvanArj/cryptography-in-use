//
//  RDNSequence.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class RDNSequence : AsnSequnce {
    
    private var _relativeDistinguishedName : [RelativeDistinguishedName] = []
    
    func add(value : RelativeDistinguishedName) {
        self._relativeDistinguishedName.append(value)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return self._relativeDistinguishedName
    }
}
