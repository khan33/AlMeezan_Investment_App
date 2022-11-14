//
//  OTPGeneratorEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum OTPViewControllerEntity {
    
// MARK: - Request Body ENCRYPTION
    struct OTPViewControllerRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        let cnic : String?
        let moible : String?
        let email : String?
        let simOwner: String

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case cnic = "CNIC"
            case moible = "Mobile"
            case email = "Email"
            case simOwner = "SimOwner"
        }
    }
    
// MARK: - OTP Generate Request Model
    class OTPViewControllerRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.OTP_SEND
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
    struct OTPResponseModel : Codable {
        let errID : String?
        let sMSPin : String?
        let emailPin : String?
        enum CodingKeys: String, CodingKey {
            case errID = "ErrID"
            case sMSPin = "SMSPin"
            case emailPin = "EmailPin"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            errID = try values.decodeIfPresent(String.self, forKey: .errID)
            sMSPin = try values.decodeIfPresent(String.self, forKey: .sMSPin)
            emailPin = try values.decodeIfPresent(String.self, forKey: .emailPin)
        }
    }
}


struct FundRequest: Codable {
    var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
    var password :   String?        =   KeychainWrapper.standard.string(forKey: "AccessToken")
    let CNIC : String?
    let fundID : String?
    let agentID : String?
    let amount : String?
    let bank : String?
    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case password = "AccessToken"
        case CNIC = "CNIC"
        case fundID = "FundID"
        case agentID = "AgentID"
        case amount = "Amount"
        case bank = "Bank"
        
    }
}


// MARK: - Investment fund Request
struct InvestmentFundRequest: Codable {
    
    var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
    var password :   String?        =   KeychainWrapper.standard.string(forKey: "AccessToken")
    let isOnline : String?
    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case password = "AccessToken"
        case isOnline = "IsOnline"
    }
}
// MARK: - Investment fund Request Model
class InvestmentFundRequestModel : RequestModel {
    private var KeyValue: String
    
    init(KeyValue: String) {
        self.KeyValue = KeyValue
    }
    
    override var path: String {
        return Constant.ServiceConstant.FUNDS_INVESTMENT
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
class InvestmentFundSubmitRequestModel : RequestModel {
    private var KeyValue: String
    
    init(KeyValue: String) {
        self.KeyValue = KeyValue
    }
    
    override var path: String {
        return Constant.ServiceConstant.ACCOUNT_OPENING_INVESTMENT
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
