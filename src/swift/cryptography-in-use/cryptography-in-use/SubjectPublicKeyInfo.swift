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
    
    static func asn1decode(asn1: ASN1Object) -> SubjectPublicKeyInfo? {
        if(asn1.tag != .universal(.sequence)) {
            return nil
        }
        let data = asn1.data.items!
        if(data.count != 2) {
            return nil
        }
        
        let algorithm = SignatureAlgorithmIdentifier.asn1decode(asn1: data[0])
        if (algorithm == nil) {
            return nil
        }
        
        let subjectPublicKey = BitString.asn1decode(asn1: data[1])
        if (subjectPublicKey == nil) {
            return nil
        }
        
        return SubjectPublicKeyInfo(algotithm: algorithm!, publicKey: subjectPublicKey!)
    }
}
