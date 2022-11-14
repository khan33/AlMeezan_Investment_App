//
//  EncryptionHelper.swift
//  AlMeezan
//
//  Created by Atta khan on 09/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
import CryptoSwift

protocol EncryptionHelperProtocol {
    func encrypt(withString jsonString: String) -> String
}

class EncryptionHelper: EncryptionHelperProtocol {
    
    func encrypt(withString jsonString: String) -> String {
        do {
            let encryptstr = try aesEncrypt(dataString: jsonString)
            return encryptstr
        } catch {
            print("Unexpected error: \(error).")
        }
        return ""
    }
    
    
    func aesEncrypt(dataString: String) throws -> String {
        let data: Data = dataString.data(using: .utf8)!
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt((data.bytes))
        let encData = Data(bytes: encrypted, count: encrypted.count)
        let base64str = encData.base64EncodedString(options: .init(rawValue: 0))
        let result = String(base64str)
        return result
    }
    
}
