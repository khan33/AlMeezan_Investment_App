//
//  SubscriptionEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

typealias subcribedRequest = SubscriptionEntity.SaveSubscriptionRequest
typealias subscriptionResponse = SubscriptionEntity.SubscriptionResponseModel
typealias subcribedResponseModel = [SubscriptionEntity.SubscriptionModel]


enum SubscriptionEntity {
    
// MARK: - Request Body ENCRYPTION
    struct SubscriptionRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
    struct SaveSubscriptionRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var customerSubscribed: [CustomerSubscribed]?
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case customerSubscribed = "CustomerSubscribed"
        }
    }
    
    
    
// MARK: - Subscription Request Model
    class SubscriptionRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.SERVICE_SUBCRIBED
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
    
    // MARK: - Save Subscription Request Model

    class SaveSubscriptionRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.CUSTOMER_SERVICES_SUBSCRIPTION
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
    
    
// MARK: -  Response Model
    struct SubscriptionResponseModel : Codable {
        let customerSubscribed : [CustomerSubscribed]?

        enum CodingKeys: String, CodingKey {
            case customerSubscribed = "CustomerSubscribed"
        }
    }
    
    struct CustomerSubscribed : Codable {
        let customerID: String?
        var mobile: String?
        let subscription, mnemonic: String?
        var isActive: Bool?
        
        enum CodingKeys: String, CodingKey {
            case customerID = "Customer_ID"
            case mobile = "Mobile"
            case subscription = "Subscription"
            case mnemonic = "Mnemonic"
            case isActive = "IsActive"
        }


    }
    
    struct ServicesAvailable : Codable {
        let iD : Int?
        let subscription : String?
        let mnemonic : String?
        let isActive : Bool?
        let timeStamp : String?

        enum CodingKeys: String, CodingKey {

            case iD = "ID"
            case subscription = "Subscription"
            case mnemonic = "Mnemonic"
            case isActive = "IsActive"
            case timeStamp = "TimeStamp"
        }
    }

    struct SubscriptionModel : Codable {
        let errID : String?
        let errMsg : String?

        enum CodingKeys: String, CodingKey {

            case errID = "ErrID"
            case errMsg = "ErrMsg"
        }
    }
}
