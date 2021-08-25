//
//  AsnSet.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class AsnSet : ASN1EncodableType {
    
    var _explicit : Bool
    var _implicitTag : UInt
    
    init(explicit : Bool = false, implicitTag : UInt = UInt.max) {
        self._explicit = explicit
        self._implicitTag = implicitTag
    }
    
    func getData() -> [ASN1EncodableType]! {
        return nil
    }
        
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        var asn1Object = try ASN1Primitive(data: .constructed(self.getData().map { try $0.asn1encode(tag: nil) }),
                                           tag: .universal(.set))
        if (self._explicit == false) {
            if(self._implicitTag != UInt.max) {
                asn1Object = try ASN1Primitive(data: .constructed(self.getData().map { try $0.asn1encode(tag: nil) }),
                                               tag: .taggedTag(self._implicitTag))
                return asn1Object
            } else {
                return asn1Object
            }
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
    
}
