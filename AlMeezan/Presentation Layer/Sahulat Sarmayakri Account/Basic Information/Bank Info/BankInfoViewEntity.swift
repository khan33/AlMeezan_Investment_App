//
//  BankInfoViewEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 12/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum BankInfoViewEntity {
    
// MARK: - Request Body ENCRYPTION
    struct BankInfoRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
// MARK: - OTP Generate Request Model
    class BankInfoRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BANK_LIST
        }
        
        override var body: [String : Any?] {
            return [
                "KeyValue"    : KeyValue
            ]
        }
        override var headers: [String : String] {
            return [
                "Content-Type" : "application/json"
            ]
        }
    }
    
    
// MARK: - OTP Generate Response Model
    struct BankInfoResponseModel : Codable {
        let BankID: String?
        let bankName : String?
        let IBANFormat: String?
        let LocalFormat: String

        enum CodingKeys: String, CodingKey {
            case BankID = "BankID"
            case bankName = "BankName"
            case IBANFormat = "IBANFormat"
            case LocalFormat = "LocalFormat"
        }


    }
}
