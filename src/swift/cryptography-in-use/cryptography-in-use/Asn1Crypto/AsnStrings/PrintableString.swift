//
//  PrintableString.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class PrintableString : AsnString {
    init(data : String, explicit: Bool = false) {
        super.init(data: data, tag: .universal(.printableString), explicit: explicit)
    }
}
