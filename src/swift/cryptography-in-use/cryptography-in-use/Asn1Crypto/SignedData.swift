//
//  SignedData.swift
//  cryptography-in-use
//
//  Created by Keyvan Arj on 6/26/21.
//

import Foundation

class SignedData : AsnSequnce {
    
    private var _version : CmsVersion!
    private var _digestAlgorithms : DigestAlgorithmIdentifiers!
    private var _encapsulatedContentInfo : EncapsulatedContentInfo!
    private var _signerInfos : SignerInfos!
    private var _certificates: Certificates!
    
    init(version: CmsVersion, explicit: Bool = false) {
        self._version = version
        self._digestAlgorithms = DigestAlgorithmIdentifiers()
        self._signerInfos = SignerInfos()
        self._certificates = Certificates(tag: 0)
        self._encapsulatedContentInfo = EncapsulatedContentInfo(oid: try! ObjectIdentifier.from(string: Oid.Data.rawValue))
        super.init(explicit: explicit)
    }
    
    func addCertificate(x509Certificate : X509Certificate) {
        let certificate = Certificate()
        certificate.loadCertificate(x509Certificate: x509Certificate)
        self._certificates.addCertficate(certificate: certificate)
    }
    
    func addDigestAlgorithm(digestAlgorithmId: DigestAlgorithmId) {
        let digestAlgorithm = DigestAlgorithmIdentifier(algorithm: digestAlgorithmId)
        self._digestAlgorithms.addDigestAlgorithmIdentifier(digestAlgorithmIdentifier: digestAlgorithm)
    }
    
    func addSignerInfo(signerInfo: SignerInfo) {
        self._signerInfos.addSignerInfo(signerInfo: signerInfo)
    }
    
    func setEncapsulatedContentInfo(content: Data) {
        let octetString = OctetString(data: content, explicit: true, tag: nil)
        self._encapsulatedContentInfo.eContent = octetString
    }
    
    override func getData() -> [ASN1EncodableType] {
        return [self._version.rawValue, self._digestAlgorithms!, self._encapsulatedContentInfo!, self._certificates, self._signerInfos]
    }
}
