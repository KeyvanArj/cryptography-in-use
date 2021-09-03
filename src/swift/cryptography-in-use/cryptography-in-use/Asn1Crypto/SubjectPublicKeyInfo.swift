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
    
    init() {
        
    }
    
    public var algorithmIdentifier : SignatureAlgorithmIdentifier? {
        get {
            return self._algorithm
        }
    }
    
    public var subjectPublicKey : BitString? {
        get {
            return self._subjectPublicKey
        }
    }
    
    init(algorithm: SignatureAlgorithmIdentifier, subjectPublicKey: BitString) {
        self._algorithm = algorithm
        self._subjectPublicKey = subjectPublicKey
    }
    
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
        
        return SubjectPublicKeyInfo(algorithm: algorithm!, subjectPublicKey: subjectPublicKey!)
    }
}
