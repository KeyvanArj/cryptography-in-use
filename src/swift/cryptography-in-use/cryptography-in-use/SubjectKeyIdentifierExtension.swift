//
//  SubjectKeyIdentifierExtension .swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/6/1400 AP.
//

import Foundation

class SubjectKeyIdentifierExtension : AsnExtension {
    
    init(value: Data) {
        let subjectKeyIdentifier = OctetString(data: value, tag: nil)
        super.init(extensionId: OID.subjectKeyIdentifier.rawValue,
                   isCritical: false,
                   extensionValue: try! subjectKeyIdentifier.asn1encode(tag: nil).serialize())
    }
}
