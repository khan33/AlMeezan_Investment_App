//
//  Entity.swift
//  AlMeezan
//
//  Created by Ahmad on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum BillListEntity {
    
    // MARK: - Request Body ENCRYPTION
    struct BillListRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
    // MARK: - Subscribe Generate Request Model
    class BillListRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BILLING_LIST
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
    
    
    // MARK: - Add Bill Generate Response Model
    
    struct BillListResponse: Codable {
        let customerid: Int?
        let billerName, utilityCompanyID, customername, billStatus: String?
        let billingMonth, dueDate: String?
        let amountWithinDueDate, amountAfterDueDate: Int?
        let accountNumber: String?
        let imagePath: String?

        enum CodingKeys: String, CodingKey {
            case customerid
            case billerName = "BillerName"
            case utilityCompanyID = "UtilityCompanyId"
            case customername
            case billStatus = "BillStatus"
            case billingMonth = "BillingMonth"
            case dueDate = "DueDate"
            case amountWithinDueDate = "AmountWithinDueDate"
            case amountAfterDueDate = "AmountAfterDueDate"
            case accountNumber = "AccountNumber"
            case imagePath = "ImagePath"
        }
    }
  
}

enum HistoryListEntity {
    
    // MARK: - Request Body ENCRYPTION
    struct HistoryListRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
    // MARK: - History Generate Request Model
    class HistoryListRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BILL_HISTORY
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
    
    
    // MARK: - Histoy List Generate Response Model
    
    struct HistoryListResponse: Codable {
        let customerID, utilityCompanyID, utilityConsumerNumber, transactionAmount: String?
        let timeStamp: String?
        var date: String?
        var formatted_date: String = ""
        
        enum CodingKeys: String, CodingKey {
            case customerID
            case utilityCompanyID = "utilityCompanyId"
            case utilityConsumerNumber, transactionAmount
            case timeStamp = "time_stamp"
            case date = "date"
        }
    }
  
}
