//
//  CMSAlgorithmProtectionAttribute.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class CMSAlgorithmProtectionAttribute : Attribute {
    
    init(digestAlgorithmId: DigestAlgorithmId, signatureAlgorithmId: SignatureAlgorithmId) {
        let digestAlgorithm = DigestAlgorithmIdentifier(algorithm: digestAlgorithmId)
        let signatureAlgorithm = SignatureAlgorithmIdentifier(algorithm: signatureAlgorithmId.rawValue,
                                                              tag: 1)
        let cmsAlgorithmProtectionValue = CMSAlgorithmProtectionValue(digestAlgorithm: digestAlgorithm, signatureAlgorithm: signatureAlgorithm)
        let cmsAlgorithmProtection = CMSAlgorithmProtection(cmsAlgorithmProtectionValue: cmsAlgorithmProtectionValue)
        let cmsAlgorithmProtectionAttrValues = AttributeValues()
        cmsAlgorithmProtectionAttrValues.add(value: cmsAlgorithmProtection)
        super.init(attrType: try! ObjectIdentifier.from(string: OID.cmsAlgorithmProtection.rawValue), attrValues: cmsAlgorithmProtectionAttrValues)
    }
}
