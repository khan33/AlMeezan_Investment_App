//
//  Manager.swift
//  AlMeezan
//
//  Created by Atta khan on 05/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import CryptoSwift
import SwiftKeychainWrapper

class Manager {
    static let shared = Manager()
    func aesDecrypt(key: String, iv: String, _ value: String) throws -> String {
        let data = Data(base64Encoded: str)!
        let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
    func aesEncrypt(dataString: String) throws -> String {
        let data: Data = dataString.data(using: .utf8)!
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt((data.bytes))
        let encData = Data(bytes: encrypted, count: encrypted.count)
        
        //key, iv: iv
        let base64str = encData.base64EncodedString(options: .init(rawValue: 0))
        let result = String(base64str)
        return result
        
        
    }
}

struct RequestBody: Codable {
    var CustomerID  :   String? = KeychainWrapper.standard.string(forKey: "CustomerId")
    var AccessToken :   String? = KeychainWrapper.standard.string(forKey: "AccessToken")
    var Date        :   String?
    var StartDate   :   String?
    var EndDate     :   String?
    var Stock       :   String?
    var type        :   String?
    //calculator params
    var Fundid          :   String?
    var PortfolioID :   String?
    var FromFundAgentID :   String?
    var ToFundAgentID   :   String?
    var TransactionType     :   String?
    var TransactionDescription  :   String?
    var ExpectedAmount  :   String?
    var TransactionDate :   String?
    var FundID          :   String?
    var AgentID         :   String?
    var Amount          :   String?
    var Bank            :   String?
    
    var City            :   String?
    var IsInternational :   String?
    var Username        :   String? //= KeychainWrapper.standard.string(forKey: "CustomerId")
    var Password        :   String? //= KeychainWrapper.standard.string(forKey: "AccessToken")
    var FundType        :   String?
    var Age             :   String?
    var AnnualIncome    :   String?
    var VPSAmount       :   String?
    var FundsAmount     :   String?
    var Plan1           :   String?
    var Plan2           :   String?
    var CurrentAge      :   String?
    var DurationOfMIPP  :   String?
    var MonthlyIncome   :   String?
    var AnnualIncomeInc :   String?
    var ToBeInvestInMTPF:   String?
    var retirementAge   :   String?
    var Score       :   Int?
    var Status      :   String?
    var ComplainID  :   String?
    var ComplainType    :   String?
    var CNIC        :   String?
    var Name        :   String?
    var EmailID     :   String?
    var MobileNo    :   String?
    var Subject     :   String?
    var Mobile      :   String?
    var Email       :   String?
    var DOB         :   String?
    var DeviceID    :   String?
    var Message     :   String?
    var MSGID       :    String?
    var Key         :   String?
    var GuestID     :   String?

    var SMSPin      :   String?
    var EmailPin    :   String?
    var LoginType   :   String?
    
    var FullName        :   String?
    var FHusbandName    :   String?
    var Gender          :   String?
    var Country         :   String?
    var Dob             :   String?
    var Cnic            :   String?
    var CnicIssueDate   :   String?
    var CnicExpiryDate  :   String?
    var Occupation      :   String?
    var SourceOfFund    :   String?
    var Address         :   String?
    var BankName        :   String?
    var BankAccNo       :   String?
    var BankBranch      :   String?
    var BankCity        :   String?
    var UserId          :   String?
    var UserPass        :   String?
    var DeviceName      :   String?
    var Platform        :   String?
    var BiometricType   :   String?
    var Index           :   String?
    var AccountType     :   String?
    var DaoID           :   String?
    
    func encryptData(_ data: RequestBody) -> [String : Any] {
        
        let encode = JSONEncoder()
        let jsonData = try! encode.encode(data)
        var jsonString = String(data: jsonData, encoding: .utf8)!
        if jsonString.contains("\\/") {
            jsonString = jsonString.replacingOccurrences(of: "\\/", with: "/", options: NSString.CompareOptions.literal, range: nil)
        }
        var params  =    [ : ] as [String : Any]
        
        switch environment {
        case .production:
            do {
                let encryptstr = try Manager.shared.aesEncrypt(dataString: jsonString)
                params = ["KeyValue": "\(encryptstr)"]
            } catch {
                print("Unexpected error: \(error).")
            }
        case .development:
            do {
                let encryptstr = try Manager.shared.aesEncrypt(dataString: jsonString)
                params = ["KeyValue": "\(encryptstr)"]
            } catch {
                print("Unexpected error: \(error).")
            }
            //params = ["KeyValue": "\(jsonString)"]
        }
        print("decrypt params = ", params)
        return params
    }
    func encryptMsgData(_ data: RequestBody, _ message: String) -> [String : Any] {
        let encode = JSONEncoder()
        let jsonData = try! encode.encode(data)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        var params  =    [ : ] as [String : Any]
        switch environment {
        case .production:
            do {
                let encryptstr = try Manager.shared.aesEncrypt(dataString: jsonString)
                let encryptMsg = try Manager.shared.aesEncrypt(dataString: message)
                params = ["KeyValue": "\(encryptstr)", "Message": encryptMsg]
            } catch {
                print("Unexpected error: \(error).")
            }
        case .development:
            do {
                let encryptstr = try Manager.shared.aesEncrypt(dataString: jsonString)
                let encryptMsg = try Manager.shared.aesEncrypt(dataString: message)
                params = ["KeyValue": "\(encryptstr)", "Message": encryptMsg]
            } catch {
                print("Unexpected error: \(error).")
            }
            //params = ["KeyValue": "\(jsonString)", "Message": message]
        }
        return params
    }
    
    func encryptComplainData(_ data: RequestBody, _ message: String) -> [String : Any] {
        let encode = JSONEncoder()
        let jsonData = try! encode.encode(data)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        var params  =    [ : ] as [String : Any]
        switch environment {
        case .production:
            do {
                let encryptstr = try Manager.shared.aesEncrypt(dataString: jsonString)
                let encryptMsg = try Manager.shared.aesEncrypt(dataString: message)
                params = ["KeyValue": "\(encryptstr)", "ComplainMessage": encryptMsg]
            } catch {
                print("Unexpected error: \(error).")
            }
        case .development:
            do {
                let encryptstr = try Manager.shared.aesEncrypt(dataString: jsonString)
                let encryptMsg = try Manager.shared.aesEncrypt(dataString: message)
                params = ["KeyValue": "\(encryptstr)", "ComplainMessage": encryptMsg]
            } catch {
                print("Unexpected error: \(error).")
            }
            //params = ["KeyValue": "\(jsonString)", "ComplainMessage": message]
        }
        return params
    }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else{ return defaultValue}
            do{
                let value = try JSONDecoder().decode(T.self, from: data)
                return value
            }catch let error{
                print(error.localizedDescription)
                return defaultValue
            }
        }
        set {
            do{
                let encodedData = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(encodedData, forKey: key)
                UserDefaults.standard.synchronize()
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
}

struct UserDefaultsConfig {
    @UserDefault("Indices", defaultValue: [IndicesObject]())
    static var indicesList: [IndicesObject]?
}

struct IndicesObject : Codable {
    var indices: [String] = []
    
}
