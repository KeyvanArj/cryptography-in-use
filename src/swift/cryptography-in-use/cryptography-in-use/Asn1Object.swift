//
//  Asn1Object.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

class Asn1Object {
    
    var _type : Asn1Type!
    var _modifier : Asn1Modifier!
    
    init(type: Asn1Type, modifier: Asn1Modifier) {
        self._type = type
        self._modifier = modifier
    }
}
