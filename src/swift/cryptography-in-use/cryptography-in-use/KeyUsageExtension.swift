//
//  File.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class KeyUsageExtension : AsnExtension {
    
    init(value: [Bool]) {
        
        var originalKeyUsage = value
        originalKeyUsage.append(contentsOf: repeatElement(false, count: 16 - originalKeyUsage.count))
        
        var keyUsageValue : UInt16 = 0x00
        var unused = 0
        var countUnusedBits = true
        for index in stride(from: originalKeyUsage.count-1, to: -1, by: -1) {
            if(!originalKeyUsage[index] && countUnusedBits) {
                unused += 1
            }
            else {
                countUnusedBits = false
                if(originalKeyUsage[index]) {
                    keyUsageValue |= 1 << index
                }
            }
        }
        var byteArray = keyUsageValue.toBytes
        if(keyUsageValue < 256) {
            byteArray.remove(at: 0)
            unused -= 8
            byteArray[0] = byteArray[0] << unused
        }
        else {
            keyUsageValue = keyUsageValue << unused
            byteArray = keyUsageValue.toBytes
        }
        
        let bitString = try! Data(byteArray).asn1bitStringEncode(unused: unused, tag: nil).serialize()
        
        super.init(extensionId: OID.keyUsage.rawValue, isCritical: true, extensionValue: bitString)
    }
}
