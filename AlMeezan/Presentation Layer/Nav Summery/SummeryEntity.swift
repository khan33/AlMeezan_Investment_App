//
//  SummeryEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum SummeryEntity {
    // MARK: - Request Body ENCRYPTION
    struct SummeryRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var accessToken :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        var fundId      :   String?
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case accessToken = "AccessToken"
            case fundId = "FundID"
        }
    }
    // MARK: - Summery Request Model
    class SummeryRequestModel : RequestModel {
        
        // MARK: - PROPERTIES
        
        private var KeyValue: String
       
        init(KeyValue: String) {
            self.KeyValue = KeyValue
            
        }
        override var path: String {
            return Constant.ServiceConstant.NAV_HISTROY
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
    // MARK: - Summery Response Model
    struct SummeryResponseModel {
        var summery : [FundHistoryModel]
    }
    
    //MARK: - Summery VIEW MODEL
    struct SummeryViewModel {
        struct DisplayedSummeryFund {
            var fundName: String?
            var fundHistory: [History]?
        }
        var displaySummeryFund: [DisplayedSummeryFund]
    }
}

