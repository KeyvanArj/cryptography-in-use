//
//  Extension.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/3/1400 AP.
//

import Foundation

class AsnExtension : AsnSequnce {
    
    private var _extnId : ObjectIdentifier!
    private var _critical : Bool!
    private var _extnValue : OctetString!
    
    init(extensionId: String, isCritical: Bool, extensionValue: Data) {
        self._extnId = try! ObjectIdentifier.from(string: extensionId)
        self._critical = isCritical
        self._extnValue = OctetString(data: extensionValue, tag: nil)
    }
    
    override func getData() -> [ASN1EncodableType]! {
        if(self._critical) {
            return [self._extnId, self._critical, self._extnValue]
        }
        else {
            return [self._extnId, self._extnValue]
        }
    }
}
