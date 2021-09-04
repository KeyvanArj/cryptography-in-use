//
//  SignerInfos.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class SignerInfos : AsnSet {
    
    private var _signerInfos : [SignerInfo] = []
    
    func addSignerInfo(signerInfo: SignerInfo) {
        self._signerInfos.append(signerInfo)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return self._signerInfos
    }
}
