//
//  BillPaymentEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


typealias addbill = BillPaymentEntity.AddBillRequest
typealias billPyament = BillPaymentEntity.BillPaymentRequest
typealias billInquiry = BillPaymentEntity.BillInquiryRequest



enum BillPaymentEntity {
    
// MARK: - Request Body
    struct BillingRequest: Codable {
        var customerID:     String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password:       String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
    struct BillInquiryRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var transmissionDate: String?
        var transmissionTime: String?
        var utilityCompanyId: String?
        var utilityConsumerNumber: String?
        var nickName: String?
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case transmissionDate = "transmissionDate"
            case transmissionTime = "transmissionTime"
            case utilityCompanyId = "utilityCompanyId"
            case utilityConsumerNumber = "utilityConsumerNumber"
            case nickName = "nickName"
        }
    }
    
    struct AddBillRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var BillerName: String?
        var UtilityCompanyId: String?
        var CustomerName: String?
        var BillStatus: String?
        var BillingMonth: String?
        var DueDate: String?
        var AmountWithinDueDate: String?
        var AmountAfterDueDate: String?
        
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case BillerName = "BillerName"
            case UtilityCompanyId = "UtilityCompanyId"
            case CustomerName = "CustomerName"
            case BillStatus = "BillStatus"
            case BillingMonth = "BillingMonth"
            case DueDate = "DueDate"
            case AmountWithinDueDate = "AmountWithinDueDate"
            case AmountAfterDueDate = "AmountAfterDueDate"
        }
    }
    
    struct BillPaymentRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var transmissionDate: String?
        var transmissionTime: String?
        var accountNumber: String?
        var utilityCompanyId: String?
        var utilityConsumerNumber: String?
        var transactionAmount: String?
        var branchCode: String?
        var branchName: String?
        
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case transmissionDate = "transmissionDate"
            case transmissionTime = "transmissionTime"
            case accountNumber = "accountNumber"
            case utilityCompanyId = "utilityCompanyId"
            case utilityConsumerNumber = "utilityConsumerNumber"
            case transactionAmount = "transactionAmount"
            case branchCode = "branchCode"
            case branchName = "branchName"
        }
    }
    
    struct BillMerchantListRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            
        }
    }
    
    
// MARK: - Payee Request Model
    class BillingRequestModel : RequestModel {
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
    
    class AddBillRequestModel : RequestModel {
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
    
    class BillPaymentRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BILL_PAYMENT
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
    
    class BillMerchantRequestModel : RequestModel {
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
    
    
    
    
// MARK: - Payee Response Model
    struct BillListResponseModel : Codable {
        let customerid : Int?
        let billerName : String?
        let utilityCompanyId : String?
        let customername : String?
        let billStatus : String?
        let billingMonth : String?
        let dueDate : String?
        let amountWithinDueDate : Double?
        let amountAfterDueDate : Double?

        enum CodingKeys: String, CodingKey {

            case customerid = "customerid"
            case billerName = "BillerName"
            case utilityCompanyId = "UtilityCompanyId"
            case customername = "customername"
            case billStatus = "BillStatus"
            case billingMonth = "BillingMonth"
            case dueDate = "DueDate"
            case amountWithinDueDate = "AmountWithinDueDate"
            case amountAfterDueDate = "AmountAfterDueDate"
        }
    }
    
    struct BillInquiryResponseModel : Codable {
        let utilityCompanyId : String?
        let customerName : String?
        let billStatus : String?
        let billingMonth : String?
        let dueDate : String?
        let amountWithinDueDate : String?
        let amountAfterDueDate : String?

        enum CodingKeys: String, CodingKey {

            case utilityCompanyId = "UtilityCompanyId"
            case customerName = "CustomerName"
            case billStatus = "BillStatus"
            case billingMonth = "BillingMonth"
            case dueDate = "DueDate"
            case amountWithinDueDate = "AmountWithinDueDate"
            case amountAfterDueDate = "AmountAfterDueDate"
        }
    }
    
    struct AddBillResponseModel : Codable {
        let errID : String?
        let errMsg : String?

        enum CodingKeys: String, CodingKey {

            case errID = "ErrID"
            case errMsg = "ErrMsg"
        }
    }
    
    struct BillPaymentResponseModel : Codable {
        let responseCode : String?
        let authIdResponse : String?
        let transactionLogID : String?
        let clientID : String?
        let channelID : String?
        let stan : String?
        let companyCode : String?
        let consumerNo : String?
        let authID : String?
        let rRN : String?
        let responseDetail : String?
        let reserved1 : String?
        let reserved2 : String?

        enum CodingKeys: String, CodingKey {

            case responseCode = "ResponseCode"
            case authIdResponse = "AuthIdResponse"
            case transactionLogID = "TransactionLogID"
            case clientID = "ClientID"
            case channelID = "ChannelID"
            case stan = "Stan"
            case companyCode = "CompanyCode"
            case consumerNo = "ConsumerNo"
            case authID = "AuthID"
            case rRN = "RRN"
            case responseDetail = "ResponseDetail"
            case reserved1 = "Reserved1"
            case reserved2 = "Reserved2"
        }
    }
    
    struct BillMerchantResponseModel : Codable {
        let billCompanyId : Int?
        let billCompany : String?
        let companyid : String?

        enum CodingKeys: String, CodingKey {

            case billCompanyId = "BillCompanyId"
            case billCompany = "BillCompany"
            case companyid = "companyid"
        }
    }
    
}
