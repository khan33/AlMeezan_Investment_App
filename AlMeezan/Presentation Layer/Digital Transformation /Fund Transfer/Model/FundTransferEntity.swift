//
//  FundTransferEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


typealias fetchTitleRequest = FundTransferEntity.FetchTitleRequest
typealias fetchPayeeHistoryRequest = FundTransferEntity.FetchTitleRequest
typealias addPayeeRequestData = FundTransferEntity.AddPayeeRequest
typealias fundTransferData = FundTransferEntity.FundTransferRequest
typealias payeeHistoryResponse = [FundTransferEntity.PayeeHistroyModel]
typealias payeeListResponse = [FundTransferEntity.PayeeResponseModel]
typealias bankListResponse = [BankInfoViewEntity.BankInfoResponseModel]?
typealias fetchTitleResponse = [FundTransferEntity.FetchPayeeTitleResponseModel]
typealias otpVerificationReqeust = FundTransferEntity.OTPVerificationRequest
typealias otpVerifcationResponse = [FundTransferEntity.OTPVerifcationModel]


enum FundTransferEntity {
    
// MARK: - Request Body
    struct PayeeRequest: Codable {
        var customerID:     String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password:       String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    struct PayeeHistoryRequest: Codable {
        var customerID:     String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password:       String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
    
    struct FetchTitleRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var transmissionDate: String?
        var transmissionTime: String?
        var accountNumber: String?
        var bankName: String?
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case transmissionDate = "transmissionDate"
            case transmissionTime = "transmissionTime"
            case accountNumber = "accountNumber"
            case bankName = "BankName"
        }
    }
    
    struct AddPayeeRequest: Codable {
        
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var BeneficiaryNickName: String?
        var BankAccountTitle: String?
        var BankBranch: String?
        var BankName: String?
        var BankAccountNo: String?
        var mobile: String?
        var email: String?
        var relationship: String?
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case BeneficiaryNickName = "BeneficiaryNickName"
            case BankAccountTitle = "BankAccountTitle"
            case BankBranch = "BankBranch"
            case BankName = "BankName"
            case BankAccountNo = "BankAccountNo"
            case mobile = "Mobile"
            case email = "Email"
            case relationship = "Relationship"
        }
    }
    
    struct FundTransferRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var transmissionDate: String?
        var transmissionTime: String?
        var fromPortfolio: String?
        var toAccountNumber: String?
        var transactionAmount: String?
        var beneficiaryTitle: String?
        var beneficiaryBranch: String?
        var beneficiaryBank: String?
        var beneficiaryIBAN: String?
        
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case transmissionDate = "transmissionDate"
            case transmissionTime = "transmissionTime"
            case fromPortfolio = "FromPortfolio"
            case toAccountNumber = "toAccountNumber"
            case transactionAmount = "transactionAmount"
            case beneficiaryTitle = "beneficiaryTitle"
            case beneficiaryBranch = "beneficiaryBranch"
            case beneficiaryBank = "beneficiaryBank"
            case beneficiaryIBAN = "beneficiaryIBAN"
        }
    }
    
    struct BankListRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            
        }
    }
    struct OTPVerificationRequest: Codable {
        var Otp:     String?
        var uniqueId:       String?

        enum CodingKeys: String, CodingKey {
            case Otp = "Otp"
            case uniqueId = "uniqueId"
        }
    }
    
// MARK: - Payee Request Model
    class PayeeRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.PAYEE_LIST
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
    
    class PayeeHistoryRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.PAYEE_HISTORY
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
    
    
    
    class AddPayeeRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.ADD_PAYEE
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
    
    class FetchPayeeTitleRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.FETCH_PAYEE_TITEL
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
    
    class IBFTRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.IBFT
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
    
    class BankListRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BANK_LIST_FOR_PAYEE
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
    
    class  OTPVerificationRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.OTP_VERIFICATION_PAYMENT
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
    struct PayeeResponseModel : Codable {
        let customerID : String?
        let beneficiaryNickName : String?
        let bankName : String?
        let bankAccountTitle : String?
        let bankAccountNo : String?
        let bankBranch : String?
        let ImagePath: String?

        enum CodingKeys: String, CodingKey {

            case customerID = "CustomerID"
            case beneficiaryNickName = "BeneficiaryNickName"
            case bankName = "BankName"
            case bankAccountTitle = "BankAccountTitle"
            case bankAccountNo = "BankAccountNo"
            case bankBranch = "BankBranch"
            case ImagePath = "ImagePath"
        }
    }
    
    struct FetchPayeeTitleResponseModel : Codable {
        let responseCode : String?
        let authIdResponse : String?
        let transactionLogID : String?
        let accountTitle : String?
        let branchName : String?
        let bankName : String?
        let beneficiaryIBAN : String?

        enum CodingKeys: String, CodingKey {

            case responseCode = "ResponseCode"
            case authIdResponse = "AuthIdResponse"
            case transactionLogID = "TransactionLogID"
            case accountTitle = "AccountTitle"
            case branchName = "BranchName"
            case bankName = "BankName"
            case beneficiaryIBAN = "BeneficiaryIBAN"
        }
    }
    
    struct AddPayeeResponseModel : Codable {
        let errID : String?
        let errMsg : String?
        let uniqueId: String?

        enum CodingKeys: String, CodingKey {

            case errID = "ErrID"
            case errMsg = "ErrMsg"
            case uniqueId = "uniqueId"
        }
    }
    
    struct IBFTResponseModel : Codable {
        let responseCode : String?
        let transactionLogID : String?

        enum CodingKeys: String, CodingKey {

            case responseCode = "ResponseCode"
            case transactionLogID = "TransactionLogID"
        }
    }
    
    struct PayeeHistroyModel : Codable {
        let customerID : String?
        let fromAccountNumber: String?
        let toAccountNumber: String?
        let beneficiaryTitle: String?
        let utilityCompanyId : String?
        let utilityConsumerNumber : String?
        let transactionAmount : String?
        let time_stamp : String?
        var formatted_date: String = ""
        var type: String = "bill"
        enum CodingKeys: String, CodingKey {

            case customerID = "customerID"
            case fromAccountNumber = "fromAccountNumber"
            case toAccountNumber = "toAccountNumber"
            case beneficiaryTitle = "beneficiaryTitle"
            case utilityCompanyId = "utilityCompanyId"
            case utilityConsumerNumber = "utilityConsumerNumber"
            case transactionAmount = "transactionAmount"
            case time_stamp = "time_stamp"
        }
    }
    
    struct OTPVerifcationModel : Codable {
        let ErrID : String?
        let ErrMsg : String?

        enum CodingKeys: String, CodingKey {

            case ErrID = "ErrID"
            case ErrMsg = "ErrMsg"
        }
    }
    
}
