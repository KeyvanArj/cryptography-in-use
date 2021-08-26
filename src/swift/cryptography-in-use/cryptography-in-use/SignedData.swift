//
//  SignedData.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

class SignedData : Asn1Sequence {
    
    var _version : CmsVersion!
    var _digestAlgorithms : DigestAlgorithmIdentifiers
    
    init(version: CmsVersion) {
        super.init(modifier: Asn1Modifier.IMPLICIT)
        self._version = version
    }
}
