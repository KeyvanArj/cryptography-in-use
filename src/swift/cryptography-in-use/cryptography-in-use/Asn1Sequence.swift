//
//  Asn1Sequence.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

class Asn1Sequence : Asn1Object {
    
    init(modifier : Asn1Modifier) {
        super.init(type: Asn1Type.SEQ, modifier: modifier)
    }
}
