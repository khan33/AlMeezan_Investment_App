//
//  ForexEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum ForexEntity {
    //MARK: - VIEW MODEL
    
    struct ForexViewModel {
        
        let symbol: String
        let close: Float
        let open: Float
        
        init(_ result: ForexModel) {
            symbol = result.symbol ?? ""
            close = result.close
            open = result.open
        }
    }
    // MARK: - Request Body ENCRYPTION
    
    struct ForexRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var accessToken :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        let startDate   :   String?     =   Date().toString(format: "yyyyMMdd")
        let endDate     :   String?     =   Date().toString(format: "yyyyMMdd")

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case accessToken = "AccessToken"
            case startDate = "StartDate"
            case endDate = "EndDate"
        }
    }
    
    
    
    
    // MARK: - Forex Request Model
    class ForexRequestModel : RequestModel {
        
        // MARK: - PROPERTIES
        
        private var KeyValue: String
       
        init(KeyValue: String) {
            self.KeyValue = KeyValue
            
        }
        override var path: String {
            return Constant.ServiceConstant.FOREX_SPOT
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
    struct ForexResponseModel: Codable {
        var forex_data: [ForexModel]?
    }
    
}
