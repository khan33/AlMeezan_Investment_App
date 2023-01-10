//
//  LoginEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 09/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

enum LoginEntity {
    
    // MARK: - Login ViewModel
    
    struct LoginViewModel {
        let statusCode  : String?
        let customerid  : String?
        let tokenID     : String?
        let dataStatus  : String?
        let errorId     : String?
        
        var hasErrorid: Bool {
            guard let errId = errorId else {
                return false
            }
            return true
        }
        
    }
    
    // MARK: - Request Body ENCRYPTION
    
    struct LoginRequest: Codable {
        let customerID: String?
        let password : String?
        let device_id : String?
        let guest_key : String?
        let loginType : String?

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "Password"
            case device_id = "DeviceID"
            case guest_key = "GuestID"
            case loginType = "LoginType"
        }
    }
    
    
    
    
    // MARK: - Login Request Model
    class LoginRequestModel : RequestModel {
        private var KeyValue: String
        init(KeyValue: String) {
            self.KeyValue = KeyValue
            
        }
        override var path: String {
            return Constant.ServiceConstant.CUSTOMER_LOGIN
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
    
    // MARK: - Login Response Model
    struct LoginResponseModel: Codable {
        let statusCode : String?
        let customerid : String?
        let tokenID : String?
        let dataStatus : String?
        let errId: String?
        var IsNPSShow: Int?
        var isCorporateId: Bool = false
        
        enum CodingKeys: String, CodingKey {
            case statusCode = "statusCode"
            case customerid = "Customerid"
            case tokenID = "tokenID"
            case dataStatus = "DataStatus"
            case errId = "ErrID"
            case IsNPSShow = "IsNPSShow"
        }
        init(from decoder: Decoder) throws {
            let values  = try decoder.container(keyedBy: CodingKeys.self)
            statusCode  = try values.decodeIfPresent(String.self, forKey: .statusCode)
            customerid  = try values.decodeIfPresent(String.self, forKey: .customerid)
            tokenID     = try values.decodeIfPresent(String.self, forKey: .tokenID)
            dataStatus  = try values.decodeIfPresent(String.self, forKey: .dataStatus)
            errId       = try values.decodeIfPresent(String.self, forKey: .errId)
            IsNPSShow   = try values.decodeIfPresent(Int.self, forKey: .IsNPSShow)
        }
    }
}
