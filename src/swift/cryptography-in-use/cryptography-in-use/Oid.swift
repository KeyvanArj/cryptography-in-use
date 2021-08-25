//
//  Oid.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

enum Oid : String {
    case Data = "1.2.840.113549.1.7.1"
    case SignedData = "1.2.840.113549.1.7.2"
    case EnvelopedData = "1.2.840.113549.1.7.3"
    case SignedAndEnvelopedData = "1.2.840.113549.1.7.4"
    case DigestedData = "1.2.840.113549.1.7.5"
    case EncryptedData = "1.2.840.113549.1.7.6"
    case AuthenticatedData = "1.2.840.113549.1.9.16.1.2"
    case CompressedData = "1.2.840.113549.1.9.16.1.9"
    case AuthenticatedEnvelopedData = "1.2.840.113549.1.9.16.1.23"
    case CountryName = "2.5.4.6"
    case StateOrProvinceName = "2.5.4.8"
    case LocalityName = "2.5.4.7"
    case OrganizationName = "2.5.4.10"
    case OrganizationalUnitName = "2.5.4.11"
    case CommonName = "2.5.4.3"
    case EmailAddress = "1.2.840.113549.1.9.1"
    case SurName = "2.5.4.4"
    case GivenName = "2.5.4.42"
    case SerialNumber = "2.5.4.5"
}
