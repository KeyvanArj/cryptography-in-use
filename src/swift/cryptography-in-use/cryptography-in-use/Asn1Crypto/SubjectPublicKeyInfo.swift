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
    
    func pem() -> String {
        var pemContent = "-----BEGIN PUBLIC KEY-----\n"
        let derContent : String = try! self.asn1encode(tag: nil).serialize().base64EncodedString()
        print("DER Content : ", derContent)
        let lines = derContent.split(by: 64)
        pemContent = pemContent + lines.joined(separator: "\n")
        pemContent = pemContent + "\n-----END PUBLIC KEY-----"
        print("PEM Content : ", pemContent)
        return pemContent
    }
    
    static func from(pem: String) -> SubjectPublicKeyInfo? {
        var base64Content = pem.replacingOccurrences(of: "\n", with: "")
        base64Content = base64Content.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----", with: "")
        base64Content = base64Content.replacingOccurrences(of: "-----END PUBLIC KEY-----", with: "")
        let derContent = Data(base64Encoded: base64Content)!
        let asn1 = try! ASN1Decoder.decode(asn1: derContent)
        return SubjectPublicKeyInfo.asn1decode(asn1: asn1)
    }
}
