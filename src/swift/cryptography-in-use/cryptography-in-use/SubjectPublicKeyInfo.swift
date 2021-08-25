//
//  SubjectPublicKeyInfo.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class SubjectPublicKeyInfo : AsnSequnce {
    
    var _algorithm : SignatureAlgorithmIdentifier
    var _subjectPublicKey : BitString
    
    init(algotithm: SignatureAlgorithmIdentifier, publicKey: BitString){
        self._algorithm = algotithm
        self._subjectPublicKey = publicKey
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._algorithm, self._subjectPublicKey]
    }
    
}
