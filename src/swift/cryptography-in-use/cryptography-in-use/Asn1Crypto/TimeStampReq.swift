//
//  TimeStampReq.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/30/1400 AP.
//

import Foundation

class TimeStampReq: AsnSequnce {
    
    private var _version: Int
    private var _messageImprint: MessageImprint
    private var _nonce: Int
    
    init(version: Int, messageImprint: MessageImprint, nonce: Int) {
        self._version = version
        self._messageImprint = messageImprint
        self._nonce = nonce
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._version, self._messageImprint, self._nonce]
    }
}
