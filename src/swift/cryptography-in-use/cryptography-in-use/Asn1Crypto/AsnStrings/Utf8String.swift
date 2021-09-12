//
//  Utf8String.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class Utf8String : AsnString {
    init(data : String, explicit: Bool = false) {
        super.init(data: data, tag: .universal(.utf8String), explicit:explicit)
    }
}
