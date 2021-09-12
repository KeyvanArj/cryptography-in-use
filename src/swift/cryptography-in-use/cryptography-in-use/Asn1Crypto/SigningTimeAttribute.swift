//
//  SigningTimeAttribute.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class SigningTimeAttribute : Attribute {
    
    init(value: Date) {
        let signingTimeValue = SigningTime(value: value)
        let signingTimeAttrValues = AttributeValues()
        signingTimeAttrValues.add(value: signingTimeValue)
        super.init(attrType: try! ObjectIdentifier.from(string: OID.signingTime.rawValue), attrValues: signingTimeAttrValues)
    }
}
