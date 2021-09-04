//
//  Certificate.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 5/6/1400 AP.
//

import Foundation

class Certificate : AsnSequnce {
    
    private var _tbsCertificate : TBSCertificate!
    private var _signatureAlgorithm : SignatureAlgorithmIdentifier!
    private var _signatureValue : BitString!
    
    init(explicit : Bool = false) {
        super.init(explicit: explicit)
    }
    
    func loadCertificate(x509Certificate: X509Certificate) {
 
        let tbsCertificate  = TBSCertificate()
        tbsCertificate.load(x509Certificate: x509Certificate)
        
        self._tbsCertificate = tbsCertificate
        self._signatureAlgorithm = SignatureAlgorithmIdentifier(algorithm: (x509Certificate.sigAlgOID)!)
        self._signatureValue = BitString(data: (x509Certificate.signature)!)
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._tbsCertificate, self._signatureAlgorithm, self._signatureValue]
    }
}
