//
//  MessageImprint.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/30/1400 AP.
//

import Foundation

class MessageImprint: AsnSequnce {
    
    var _hashAlgorithm: SignatureAlgorithmIdentifier
    var _hashedMessage: OctetString
    
    init(hashAlgorithm: SignatureAlgorithmIdentifier, hashedMessage: OctetString) {
        self._hashAlgorithm = hashAlgorithm
        self._hashedMessage = hashedMessage
    }
 
    override func getData() -> [ASN1EncodableType] {
        return [self._hashAlgorithm, self._hashedMessage]
    }
    
    
}
