//
//  AddBillEntity.swift
//  AlMeezan
//
//  Created by Ahmad on 30/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum AddBillEntity {
    
    // MARK: - Request Body ENCRYPTION
    struct AddBillRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
    // MARK: - AddBill Generate Request Model
    class AddBillRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BILL_MERCHANT_LIST
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
    
    struct AddBillResponse: Codable {
        let billCompanyID: String?
        let billCompany: String?
        let companyid: Int?
        let imagePath: String?

        enum CodingKeys: String, CodingKey {
            case billCompanyID = "BillCompanyId"
            case billCompany = "BillCompany"
            case companyid
            case imagePath = "ImagePath"
        }
    }
}

enum BillInquiryEntity {
    
    // MARK: - BillInquiry Request Body ENCRYPTION
    struct BillInquiryRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        let transmissionDate, transmissionTime: String?
        let utilityCompanyID, utilityConsumerNumber, nickName: String?

        enum CodingKeys: String, CodingKey {
            case customerID = "customerID"
            case password = "AccessToken"
            case transmissionDate, transmissionTime
            case utilityCompanyID = "utilityCompanyId"
            case utilityConsumerNumber, nickName
        }
    }
    
    // MARK: - BillInquiry Generate Request Model
    class BillInquiryRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BILLING_INQUIRY
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
    
    
    // MARK: - BillInquiryGenerate Response Model
    
    struct BillInquiryResponse: Codable {
        let utilityCompanyID, customerName, billStatus, billingMonth: String?
        let dueDate, amountWithinDueDate, amountAfterDueDate: String?

        enum CodingKeys: String, CodingKey {
            case utilityCompanyID = "UtilityCompanyId"
            case customerName = "CustomerName"
            case billStatus = "BillStatus"
            case billingMonth = "BillingMonth"
            case dueDate = "DueDate"
            case amountWithinDueDate = "AmountWithinDueDate"
            case amountAfterDueDate = "AmountAfterDueDate"
        }
    }
}

enum BillAddEntity {
    
    // MARK: - BillInquiry Request Body ENCRYPTION
    struct BillAddRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        let billerName, utilityCompanyID: String?
           let customerName, billStatus, billingMonth, dueDate: String?
           let amountWithinDueDate, amountAfterDueDate, accountNumber: String?

           enum CodingKeys: String, CodingKey {
               case customerID = "CustomerID"
               case password = "AccessToken"
               case billerName = "BillerName"
               case utilityCompanyID = "UtilityCompanyId"
               case customerName = "CustomerName"
               case billStatus = "BillStatus"
               case billingMonth = "BillingMonth"
               case dueDate = "DueDate"
               case amountWithinDueDate = "AmountWithinDueDate"
               case amountAfterDueDate = "AmountAfterDueDate"
               case accountNumber = "AccountNumber"
           }
    }
    
    // MARK: - BillInquiry Generate Request Model
    class BillAddRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.ADD_BILLING
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
    
    
    // MARK: - Bill Add Generate Response Model
    
    struct BillAddResponse: Codable {
        let errID, uniqueID: String?

           enum CodingKeys: String, CodingKey {
               case errID = "ErrID"
               case uniqueID
           }
    }
}
