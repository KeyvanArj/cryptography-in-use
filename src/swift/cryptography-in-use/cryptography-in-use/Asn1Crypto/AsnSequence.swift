//
//  AsnSequence.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class AsnSequnce : ASN1EncodableType {
    
    private var _explicit : Bool
    private var _tag : UInt
    
    init(explicit : Bool = false, tag : UInt = UInt.max) {
        self._explicit = explicit
        self._tag = tag
    }
    
    func getData() -> [ASN1EncodableType]! {
        return nil
    }
    
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        var asn1Primitive = try ASN1Primitive(
            data: .constructed(self.getData().map { try $0.asn1encode(tag: tag) }),
                tag: .universal(.sequence))
        if (self._explicit == false) {
            if(self._tag != UInt.max) {
                asn1Primitive = try ASN1Primitive(data: .constructed(self.getData().map { try $0.asn1encode(tag: nil) }),
                                               tag: .taggedTag(self._tag))
                return asn1Primitive
            } else {
                return asn1Primitive
            }
        } else {
            if(self._tag != UInt.max) {
                return ASN1Primitive(data: .constructed([asn1Primitive]), tag: .taggedTag(self._tag))
            } else {
                return ASN1Primitive(data: .constructed([asn1Primitive]), tag: .taggedTag(0))
            }
            
        }
    }
}
