//
//  BitString.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class BitString : ASN1EncodableType {
        
    private var _binaryData : Data
    private var _explicit : Bool
    
    init(data : Data, explicit: Bool = false) {
        self._explicit = explicit
        self._binaryData = data
    }
    
    public var binaryData : Data {
        get {
            return self._binaryData
        }
    }
    func asn1encode(tag: ASN1DecodedTag?) throws -> ASN1Object {
        let zeroPaddedBitsNum : UInt8 = 0x00
        var data = self._binaryData
        data.insert(zeroPaddedBitsNum, at: 0)
        let asn1Object = ASN1Primitive(data: .primitive(data), tag: .universal(.bitString))
        if (self._explicit == false) {
            return asn1Object
        } else {
            return ASN1Primitive(data: .constructed([asn1Object]), tag: .taggedTag(0))
        }
    }
    
    static func asn1decode(asn1: ASN1Object) -> BitString? {
        if(asn1.tag != .universal(.bitString)) {
            return nil
        }
        let publicKeyData = asn1.data.primitive!.suffix(from: 1)
        return BitString(data: publicKeyData)
    }
}
