//
//  ExtendedKeyUsageExtension.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/6/1400 AP.
//

import Foundation

class ExtendedKeyUsageExtension : AsnExtension {
    
    init(value: [String]) {
        let extendedKeyUsage = ExtendedKeyUsage(values: value)
        let extensionValue = try! extendedKeyUsage.asn1encode(tag: nil).serialize()
        super.init(extensionId: OID.extKeyUsage.rawValue, isCritical: false, extensionValue: extensionValue)
    }
}
