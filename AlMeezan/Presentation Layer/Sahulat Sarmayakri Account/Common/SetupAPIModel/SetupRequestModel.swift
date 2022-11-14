//
//  SetupRequestModel.swift
//  AlMeezan
//
//  Created by Atta khan on 30/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


// MARK: - Request Body ENCRYPTION
struct SetUpRequest: Codable {
    var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
    var accessToken :   String?     =  KeychainWrapper.standard.string(forKey: "AccessToken")
    
    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case accessToken = "AccessToken"
    }
}

// MARK: - Setup Request Model
class SetUpRequestModel : RequestModel {
    
    // MARK: - PROPERTIES
    
    private var KeyValue: String
   
    init(KeyValue: String) {
        self.KeyValue = KeyValue
        
    }
    override var path: String {
        return Constant.ServiceConstant.SETUP_API
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
