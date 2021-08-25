//
//  DigestAlgorithmIdentifiers.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/3/1400 AP.
//

import Foundation

class DigestAlgorithmIdentifiers : AsnSet {
    
    private var _digestAlgorithms : [DigestAlgorithmIdentifier] = []
    
    func addDigestAlgorithmIdentifier(digestAlgorithmIdentifier: DigestAlgorithmIdentifier) {
        self._digestAlgorithms.append(digestAlgorithmIdentifier)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return self._digestAlgorithms
    }
}
