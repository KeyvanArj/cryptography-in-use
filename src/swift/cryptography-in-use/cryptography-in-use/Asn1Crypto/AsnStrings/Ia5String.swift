//
//  Ia5String.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/5/1400 AP.
//

import Foundation

class Ia5String : AsnString {
    init(data : String, explicit: Bool = false) {
        super.init(data: data, tag: .universal(.ia5String), explicit:explicit)
    }
}
