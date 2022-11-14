//
//  ResponseModel.swift
//  AlMeezan
//
//  Created by Atta khan on 04/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import ObjectMapper




class ResponseModel2: Mappable {
    var Customerid      :   String?
    var tokenID         :   String?
    var DataStatus      :   String?
    var statusCode      :   Int?
    var ErrID           :   String?
    var Column1         :   String?
    var status          :   String?
    var calculator      :   [CalculatorModel]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        Customerid          <- map["Customerid"]
        tokenID             <- map["tokenID"]
        DataStatus          <- map["DataStatus"]
        statusCode          <- map["statusCode"]
        ErrID               <- map["ErrID"]
        Column1             <- map["Column1"]
        status              <- map["status"]
        calculator          <- map["Calculator"]
    }
}
class FundOfFundModel: Mappable {
    var Description         :   String?
    var KeyBenefits         :   String?
    var WhoShouldInvest     :   String?
    var ErrID               :   String?
    var FundCategory        :   [FundCategoryModel]?
    var isExpanded          : Bool    = false
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        Description          <- map["Description"]
        KeyBenefits          <- map["KeyBenefits"]
        WhoShouldInvest      <- map["WhoShouldInvest"]
        FundCategory          <- map["Funds"]
        ErrID               <- map["ErrID"]
    }
}
class FundCategoryModel: Mappable {
    var Serial                  :   Int?
    var Description             :   String?
    var WhoShouldInvest         :   String?
    var KeyBenefits             :   String?
    var InvestorRiskProfile     :   String?
    var MaturedInvestmentPlans  :   Int?
    var FundCategory            :   String?
    var FundName                :   String?
    var LaunchDate              :   String?
    var ManagementFee           :   String?
    var FrontEndLoad            :   String?
    var BackEndLoad             :   String?
    var MaturityDate            :   String?
    var Tenure                  :   String?
    var CumulativeReturn        :   String?
    var CumulativeBenchmarkReturn       :   String?
    var AnnualizedReturns               :   String?
    var BenchmarkAnnualizedReturns      :   String?
    var UniqueBenefit           :   String?
    var isExpanded              : Bool    = false
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        Serial          <- map["Serial"]
        Description          <- map["Description"]
        WhoShouldInvest      <- map["WhoShouldInvest"]
        KeyBenefits          <- map["KeyBenefits"]
        InvestorRiskProfile               <- map["InvestorRiskProfile"]
        MaturedInvestmentPlans          <- map["MaturedInvestmentPlans"]
        FundCategory          <- map["FundCategory"]
        FundName      <- map["FundName"]
        LaunchDate          <- map["LaunchDate"]
        ManagementFee               <- map["ManagementFee"]
        FrontEndLoad          <- map["FrontEndLoad"]
        BackEndLoad          <- map["BackEndLoad"]
        MaturityDate      <- map["MaturityDate"]
        Tenure          <- map["Tenure"]
        CumulativeReturn               <- map["CumulativeReturn"]
        CumulativeBenchmarkReturn      <- map["CumulativeBenchmarkReturn"]
        AnnualizedReturns          <- map["AnnualizedReturns"]
        BenchmarkAnnualizedReturns               <- map["BenchmarkAnnualizedReturns"]
            UniqueBenefit                   <- map["UniqueBenefit"]
    }
}


class CalculatorModel: Mappable {
    var VPSTaxRate       :   String?
    var VPSTaxCredit     :   String?
    var MFTTaxCredit     :   String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        VPSTaxRate          <- map["VPSTaxRate"]
        VPSTaxCredit        <- map["VPSTaxCredit"]
        MFTTaxCredit        <- map["MFTTaxCredit"]
    }
}

struct ResponseData: Decodable {
    var questions: [Questions]
}
struct Questions : Decodable {
    var question : String
    var id       : Int
    var options :  [Options]
    var weight  :  [Weight]?
    var isSelected: Bool = false
    var sub_questions: [Questions]?
}

struct Options: Decodable {
    var answer: String
}
struct Weight: Decodable {
    var value: Int
}


struct FilterFundsModel: Decodable {
    var FundGroup: String
    var Funds: [FundsDataModel]
}
struct FundsDataModel: Decodable {
    var EntryLoad: String
    var ExitLoad: String
    var Fund: String
    var FundCategory: String
    var FundGroup: String
    var FundSize: String
    var ManagementFee: String
    var RiskLevel: String
    var sort: Int
}




struct ContactUs: Codable {
    let statusCode : String?
    let column : String?
    enum CodingKeys: String, CodingKey {
        case statusCode = "StatusCode"
        case column = "Column1"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(String.self, forKey: .statusCode)
        column     = try values.decodeIfPresent(String.self, forKey: .column)
    }
}
struct CRMLead: Codable {
    let status : String?
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
}
