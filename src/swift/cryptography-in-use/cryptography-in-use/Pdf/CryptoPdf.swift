//
//  CryptoPdf.swift
//  cryptography-in-use
//
//  Created by Mojtaba Mirzadeh on 6/7/1400 AP.
//

import Foundation

class CryptoPdf {
    
    private var _data : Data
    
    init(data: Data) {
        self._data = data
    }
    
    public var size : Int {
        get {
            return self._data.count
        }
    }
    
    init(path: String) {
        var pdfData : [UInt8] = []
        
        let fileHandler = InputStream(fileAtPath: path)
        if(fileHandler != nil) {
            var buffer : [UInt8] = [UInt8](repeating: 0, count: 128)
            fileHandler!.open()
            while true {
                let len = fileHandler!.read(&buffer, maxLength: buffer.count)
                if (len > 0) {
                    pdfData.append(contentsOf: buffer[0...len-1])
                }
                if len < buffer.count {
                    break
                }
            }
            fileHandler!.close()
        }
        self._data = pdfData.data
    }
    
//    public var content : Data {
//        get {
//            let index = self._data.firstIndex(of: "/ByteRange")
//        }
//    }
}
