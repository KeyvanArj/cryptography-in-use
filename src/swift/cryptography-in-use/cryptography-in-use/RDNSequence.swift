//
//  RDNSequence.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class RDNSequence : AsnSequnce {
    
    var _relativeDistinguishedName : [RelativeDistinguishedName]!
    
    override func getData() -> [ASN1EncodableType] {
        return self._relativeDistinguishedName
    }
}
