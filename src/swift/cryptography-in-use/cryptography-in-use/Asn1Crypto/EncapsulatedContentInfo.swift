//
//  EncapsulatedContentInfo.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class EncapsulatedContentInfo : AsnSequnce {
    
    private var _eContentType : ObjectIdentifier
    private var _eContent : OctetString!
    
    init(oid: ObjectIdentifier) {
        self._eContentType = oid
    }
    
    var eContent : OctetString? {
        willSet {
            self._eContent = newValue
        }
    }
    
    override func getData() -> [ASN1EncodableType]! {
        return [self._eContentType, self._eContent]
    }
}
