//
//  File.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/6/1400 AP.
//

import Foundation

class AuthorityKeyIdentifierExtension : AsnExtension {
    
    init(value: Data) {
        let authorityKeyIdentifier = AuthorityKeyIdentifier(keyIdentifier: value)
        super.init(extensionId: OID.authorityKeyIdentifier.rawValue,
                   isCritical: false,
                   extensionValue: try! authorityKeyIdentifier.asn1encode(tag: nil).serialize())
    }
}
