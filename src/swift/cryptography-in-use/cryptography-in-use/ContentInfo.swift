//
//  ContentInfo.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

class ContentInfo : AsnSequnce {
        
    var _contentType : ObjectIdentifier
    var _content : ASN1EncodableType! 
    
    override func getData() -> [ASN1EncodableType] {
            return [self._contentType, self._content]
    }
    
    init(contentType: Oid) {
        self._contentType = try! ObjectIdentifier.from(string: contentType.rawValue)
    }
}

