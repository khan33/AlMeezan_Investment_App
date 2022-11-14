//
//  BillTransferEntity.swift
//  AlMeezan
//
//  Created by Ahmad on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum BillTransferEntity {
    
    // MARK: - Request Body ENCRYPTION
    struct BillTransferRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        let transmissionDate, transmissionTime: String?
        let accountNumber, utilityCompanyID, utilityConsumerNumber, transactionAmount: String?
        let branchCode, branchName: String?

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case transmissionDate, transmissionTime, accountNumber
            case utilityCompanyID = "utilityCompanyId"
            case utilityConsumerNumber, transactionAmount, branchCode, branchName
        }
    }
    
    // MARK: - AddBill Generate Request Model
    class BillTransferRequestModel : RequestModel {
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
    
    
    // MARK: - Add Bill Generate Response Model
    
    struct BillTransferResponse: Codable {
        let responseCode, authIDResponse, transactionLogID, clientID: String?
        let channelID, stan, companyCode, consumerNo: String?
        let authID, rrn, responseDetail, reserved1: String?
        let reserved2: String?

        enum CodingKeys: String, CodingKey {
            case responseCode = "ResponseCode"
            case authIDResponse = "AuthIdResponse"
            case transactionLogID = "TransactionLogID"
            case clientID = "ClientID"
            case channelID = "ChannelID"
            case stan = "Stan"
            case companyCode = "CompanyCode"
            case consumerNo = "ConsumerNo"
            case authID = "AuthID"
            case rrn = "RRN"
            case responseDetail = "ResponseDetail"
            case reserved1 = "Reserved1"
            case reserved2 = "Reserved2"
        }
    }
}
