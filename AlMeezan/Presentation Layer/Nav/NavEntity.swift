//
//  NavEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum NavEntity {
    
    //MARK: - NAV VIEW MODEL
    struct NavViewModel {
        struct DisplayedFund {
            var fundGroup: String
            var fundsort: Int32
            var navPerformance: Set<NavPerformance>
        }
        var displayFund: [DisplayedFund]
    }
    
    // MARK: - Request Body ENCRYPTION
    struct NavRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var accessToken :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        
        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case accessToken = "AccessToken"
        }
    }
    
    // MARK: - Nav Request Model
    class NavRequestModel : RequestModel {
        
        // MARK: - PROPERTIES
        
        private var KeyValue: String
       
        init(KeyValue: String) {
            self.KeyValue = KeyValue
            
        }
        override var path: String {
            return Constant.ServiceConstant.NAV_PERFORMANCE
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
    
    // MARK: - Nav Response Model
    struct NavResponseModel {
        var nav: [NavModel]
    }
}
