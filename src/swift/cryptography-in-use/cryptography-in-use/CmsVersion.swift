//
//  CmsVersion.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

enum CmsVersion : Int {
    case v0 = 0
    case v1 = 1
    case v2 = 2
    case v3 = 3
    case v4 = 4
    case v5 = 5
}

enum CertificateVersionMap : Int {
    case v1 = 0
    case v2 = 1
    case v3 = 2
}


class CertificateVersion : ASN1EncodableType {
    
    var _explicit: Bool
    var _value: CertificateVersionMap
    
    init(explicit: Bool = false, value: CertificateVersionMap) {
        self._explicit = explicit
        self._value = value
    }
    
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let asn1Object = try self._value.rawValue.asn1encode(tag: tag)
        if (self._explicit == false) {
            return asn1Object
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
}
