//
//  DigestAlgorithmIdentifier.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/3/1400 AP.
//

import Foundation

class DigestAlgorithmIdentifier : AsnSequnce {
   
    private var _algorithm : ObjectIdentifier!
    
    init(algorithm : DigestAlgorithmId) {
        self._algorithm = try! ObjectIdentifier.from(string: algorithm.rawValue)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._algorithm]
    }
}


enum  DigestAlgorithmId : String {
    case md2 = "1.2.840.113549.2.2"
    case md5 = "1.2.840.113549.2.5"
    case sha1 = "1.3.14.3.2.26"
    case sha224 = "2.16.840.1.101.3.4.2.4"
    case sha256 = "2.16.840.1.101.3.4.2.1"
    case sha384 = "2.16.840.1.101.3.4.2.2"
    case sha512 = "2.16.840.1.101.3.4.2.3"
    case sha512_224 = "2.16.840.1.101.3.4.2.5"
    case sha512_256 = "2.16.840.1.101.3.4.2.6"
    case sha3_224 = "2.16.840.1.101.3.4.2.7"
    case sha3_256 = "2.16.840.1.101.3.4.2.8"
    case sha3_384 = "2.16.840.1.101.3.4.2.9"
    case sha3_512 = "2.16.840.1.101.3.4.2.10"
    case shake128 = "2.16.840.1.101.3.4.2.11"
    case shake256 = "2.16.840.1.101.3.4.2.12"
    case shake128_len = "2.16.840.1.101.3.4.2.17"
    case shake256_len = "2.16.840.1.101.3.4.2.18"
}
