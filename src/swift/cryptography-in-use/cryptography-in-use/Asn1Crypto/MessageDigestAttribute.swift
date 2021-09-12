//
//  MessageDigestAttribute.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class MessageDigestAttribute : Attribute {
    
    init(value: String) {
        let messageDigest = MessageDigest(hexString: value)
        let messageDigestAttrValues = AttributeValues()
        messageDigestAttrValues.add(value: messageDigest)
        super.init(attrType: try! ObjectIdentifier.from(string: OID.messageDigest.rawValue), attrValues: messageDigestAttrValues)
    }
}
