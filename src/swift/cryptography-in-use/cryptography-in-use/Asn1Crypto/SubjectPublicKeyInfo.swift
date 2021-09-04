//
//  SubjectPublicKeyInfo.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class SubjectPublicKeyInfo : AsnSequnce {
    
    private var _algorithm : SignatureAlgorithmIdentifier!
    private var _subjectPublicKey : BitString!
    
    func load(publicKey: X509PublicKey) {
        let publicKeyParameters : String = (publicKey.algParams)!
        self._algorithm = SignatureAlgorithmIdentifier(algorithm: (publicKey.algOid)!,
                                                       parameter: publicKeyParameters)
        let publicKeyBytes = publicKey.key
        self._subjectPublicKey = BitString(data: publicKeyBytes!)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._algorithm, self._subjectPublicKey]
    }
    
}
