//
//  AuthorityKeyIdentifier.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/6/1400 AP.
//

import Foundation

class AuthorityKeyIdentifier : AsnSequnce {
    
    private var _keyIdentifier : OctetString
    
    init(keyIdentifier: Data) {
        self._keyIdentifier = OctetString(data: keyIdentifier, tag:.taggedTag(0))
    }
    
    override func getData() -> [ASN1EncodableType]! {
        return [_keyIdentifier]
    }
}
