//
//  ContentInfo.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

class ContentInfo : Asn1Sequence {
    
    var _contentType : Oid
    var _content : AnyObject?
    
    init(contentType: Oid) {
        self._contentType = contentType
        super.init(modifier: Asn1Modifier.IMPLICIT)
    }
}
