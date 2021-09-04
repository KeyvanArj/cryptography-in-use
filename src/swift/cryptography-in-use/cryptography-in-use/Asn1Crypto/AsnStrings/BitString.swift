//
//  BitString.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class BitString : ASN1EncodableType {
        
    private var binaryData : Data
    private var _explicit : Bool
    
    init(data : Data, explicit: Bool = false) {
        self._explicit = explicit
        
        self.binaryData = data
        let zeroPaddedBitsNum : UInt8 = 0x00
        self.binaryData.insert(zeroPaddedBitsNum, at: 0)
    }
    
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let asn1Object = ASN1Primitive(data: .primitive(self.binaryData), tag: .universal(.bitString))
        if (self._explicit == false) {
            return asn1Object
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
    
}
