//
//  SignatureAlgorithmIdentifier.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class SignatureAlgorithmIdentifier : AsnSequnce {
   
    private var _algorithm : ObjectIdentifier!
    private var _parameter : ObjectIdentifier!
    
    init(algorithm : String, parameter: String = "", explicit: Bool = false, tag: UInt = UInt.max) {
        super.init(explicit: explicit, tag: tag)
        self._algorithm = try! ObjectIdentifier.from(string: algorithm)
        if(parameter != "") {
            self._parameter = try! ObjectIdentifier.from(string: parameter)
        }
    }
    
    public var algorithm : ObjectIdentifier? {
        get {
            return self._algorithm
        }
    }
    
    public var parameter : ObjectIdentifier? {
        get {
            return self._parameter
        }
    }
    
    override func getData() -> [ASN1EncodableType] {
        if(self._parameter != nil){
            return [self._algorithm, self._parameter]
        } else {
            return [self._algorithm]
        }
    }
    
    static func asn1decode(asn1: ASN1Object) -> SignatureAlgorithmIdentifier? {
        if(asn1.tag != .universal(.sequence)) {
            return nil
        }
        let data = asn1.data.items!
        if(data.count < 1) {
            return nil
        }
        
        let algorithmAsn : ASN1Primitive = data[0] as! ASN1Primitive
        if(algorithmAsn.tag != .universal(.objectIdentifier)) {
            return nil
        }
        
        let algorithm = try! ObjectIdentifier.from(asn1: algorithmAsn)
        if (data.count > 1) {
            let parameterAsn : ASN1Primitive = data[1] as! ASN1Primitive
            if(parameterAsn.tag != .universal(.objectIdentifier)) {
                return nil
            }
            let parameter = try! ObjectIdentifier.from(asn1: parameterAsn)
            return SignatureAlgorithmIdentifier(algorithm: algorithm.rawValue, parameter: parameter.rawValue)
        }
        else {
            return SignatureAlgorithmIdentifier(algorithm: algorithm.rawValue)
        }
    }
}

enum  SignatureAlgorithmId : String {
    case dsa = "1.2.840.10040.4.1"
    case ecdsa = "1.2.840.10045.4"
    case md2_rsa = "1.2.840.113549.1.1.2"
    case md5_rsa = "1.2.840.113549.1.1.4"
    case rsassa_pkcs1v15 = "1.2.840.113549.1.1.1"
    case rsassa_pss = "1.2.840.113549.1.1.10"
    case sha1_dsa = "1.2.840.10040.4.3"
    case sha1_ecdsa = "1.2.840.10045.4.1"
    case sha1_rsa = "1.2.840.113549.1.1.5"
    case sha224_dsa = "2.16.840.1.101.3.4.3.1"
    case sha224_ecdsa = "1.2.840.10045.4.3.1"
    case sha224_rsa = "1.2.840.113549.1.1.14"
    case sha256_dsa = "2.16.840.1.101.3.4.3.2"
    case sha256_ecdsa = "1.2.840.10045.4.3.2"
    case sha256_rsa = "1.2.840.113549.1.1.11"
    case sha384_ecdsa = "1.2.840.10045.4.3.3"
    case sha384_rsa = "1.2.840.113549.1.1.12"
    case sha512_ecdsa = "1.2.840.10045.4.3.4"
    case sha512_rsa = "1.2.840.113549.1.1.13"
    case sha3_224_ecdsa = "2.16.840.1.101.3.4.3.9"
    case sha3_256_ecdsa = "2.16.840.1.101.3.4.3.10"
    case sha3_384_ecdsa = "2.16.840.1.101.3.4.3.11"
    case sha3_512_ecdsa = "2.16.840.1.101.3.4.3.12"
    case ed25519 = "1.3.101.112"
    case ed448 = "1.3.101.113"
}
