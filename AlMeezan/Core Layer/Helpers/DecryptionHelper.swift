//
//  DecryptionHelper.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import CryptoSwift

protocol DecryptionHelperProtocol {
    func decrypt(with decrptyData : String) -> Data?
}

class DecryptionHelper: DecryptionHelperProtocol {
    
    func decrypt(with decrptyData: String) -> Data? {
        guard let data = Data(base64Encoded: decrptyData) else { return nil }
        let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        //decryptedJSON(obj: Data(decrypted))
        return Data(decrypted)
    }
    
    func decryptedJSON(obj: Data) {
        let string = String(data: obj, encoding: String.Encoding.utf8) // the data will be converted to the string
        let data = string?.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
            {
                print("*******************************************************************************")
                print(jsonArray)
                print("*******************************************************************************")
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
}
