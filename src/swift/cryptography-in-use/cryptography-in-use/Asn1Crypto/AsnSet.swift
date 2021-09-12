//
//  AsnSet.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class AsnSet : ASN1EncodableType {
    
    private  var _explicit : Bool
    internal var _tag : UInt
    
    init(explicit : Bool = false, tag : UInt = UInt.max) {
        self._explicit = explicit
        self._tag = tag
    }
    
    func getData() -> [ASN1EncodableType]! {
        return nil
    }
        
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        var asn1Object = try ASN1Primitive(data: .constructed(self.getData().map { try $0.asn1encode(tag: nil) }),
                                           tag: .universal(.set))
        if (self._explicit == false) {
            if(self._tag != UInt.max) {
                asn1Object = try ASN1Primitive(data: .constructed(self.getData().map { try $0.asn1encode(tag: nil) }),
                                               tag: .taggedTag(self._tag))
                return asn1Object
            } else {
                return asn1Object
            }
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
    
}
