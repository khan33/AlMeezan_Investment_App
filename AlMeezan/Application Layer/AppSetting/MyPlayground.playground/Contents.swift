import UIKit
import CryptoSwift

var greeting = "Hello, playground"

let key = "UsmanAlmeezan123"
let iv = "Hello World12345"

var decrString = "Cz8rCh9OZqZEVJFCIDQeS885W6Cx2sIs467SLd5H2+jaxiE2DTZtL7BnFD7HQzLQHPXT6sWp10I8IA4rEc/breC54EwMo96FeEQ2jPf5THkrX7LhEaTEdEEvd8xMIyK3CgW5Wt9/au05HykfIBKbVQ=="


func aesDecrypt() throws -> String {
    let data = Data(base64Encoded: decrString)!
    let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
    let decryptedData = Data(decrypted)
    let decryptedString = String(bytes: decryptedData, encoding: .utf8)
        //String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    return decryptedString
}


let str = aesDecrypt()
print(str)
