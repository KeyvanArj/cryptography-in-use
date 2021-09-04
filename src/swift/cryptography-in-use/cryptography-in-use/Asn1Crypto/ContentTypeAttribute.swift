//
//  ContentTypeAttribute.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class ContentTypeAttribute : Attribute {
    
    init(value: String) {
        let contentType = ContentType(value: value)
        let contentTypeAttrValues = AttributeValues()
        contentTypeAttrValues.add(value: contentType)
        super.init(attrType: try! ObjectIdentifier.from(string: OID.contentType.rawValue), attrValues: contentTypeAttrValues)
    }
}
