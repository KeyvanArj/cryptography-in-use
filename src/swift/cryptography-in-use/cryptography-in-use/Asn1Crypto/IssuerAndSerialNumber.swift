//
//  IssuerAndSerialNumber.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class IssuerAndSerialNumber : AsnSequnce {
    
    private var _issuer : RDNSequence
    private var _serial : Int
    
    init(issuer : RDNSequence, serial: Int) {
        self._issuer = issuer
        self._serial = serial
    }
        
    override func getData() -> [ASN1EncodableType] {
        return [self._issuer, self._serial]
    }
}
