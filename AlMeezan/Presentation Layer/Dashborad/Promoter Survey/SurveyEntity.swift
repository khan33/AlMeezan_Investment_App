//
//  SurveyEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 19/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

struct SurveyRequestModel: Codable {
    var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
    var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
    let howLikely : String?
    let productOffering : String?
    let returns : String?
    let services: String?
    let vas: String?
    let management: String?
    let shariahCompliantValues: String?
    let otherFeedback: String?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case password = "AccessToken"
        case howLikely = "HowLikely"
        case productOffering = "ProductOffering"
        case returns = "Returns"
        case services = "Services"
        case vas = "VAS"
        case management = "Management"
        case shariahCompliantValues = "ShariahCompliantValues"
        case otherFeedback = "OtherFeedback"
    }
}

class SurveySubmissionRequestModel : RequestModel {
    private var KeyValue: String
    
    init(KeyValue: String) {
        self.KeyValue = KeyValue
    }
    
    override var path: String {
        return Constant.ServiceConstant.SURVEY_SUBMISSION
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


struct SurveyCancelModel: Codable {
    var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
    var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
    
    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case password = "AccessToken"
    }
}

class SurveyCancelRequestModel : RequestModel {
    private var KeyValue: String
    
    init(KeyValue: String) {
        self.KeyValue = KeyValue
    }
    
    override var path: String {
        return Constant.ServiceConstant.SURVEY_CANCEL
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


struct SurveyResponseModel: Codable {
    let errId: String?
    
    enum CodingKeys: String, CodingKey {
        case errId = "ErrID"
    }
    init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        errId       = try values.decodeIfPresent(String.self, forKey: .errId)
    }
}
