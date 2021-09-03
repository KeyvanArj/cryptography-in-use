//
//  Certificates.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/24/1400 AP.
//

import Foundation

class Certificates: AsnSet {
    
    private var _certificates : [Certificate]! = []
    
    func addCertficate(certificate : Certificate) {
        self._certificates.append(certificate)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return self._certificates
    }
}
