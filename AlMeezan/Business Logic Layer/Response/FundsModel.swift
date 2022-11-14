//
//  FundsModel.swift
//  AlMeezan
//
//  Created by Atta khan on 04/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import ObjectMapper

class FundsModel: Mappable {
    var fundGroup           :   String?
    var fundsList           :  [FundsList]?
    var isExpandable        :   Bool = true
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        fundGroup      <- map["FundGroup"]
        fundsList      <- map["Funds"]
        
    }
}
class FundsList: Mappable {
    var Serial                  :   Int?
    var SFID                    :   Int?
    var WhoShouldInvest         :   String?
    var PayoutPolicy            :   String?
    var Objective               :   String?
    var MinimumInvestmentAmount :   String?
    var ManagementFee           :   String?
    var LockInPeriod            :   String?
    var KeyBenefits             :   String?
    var InvestorRiskProfile     :   String?
    var FYTD                    :   Double?
    var FY4                     :   Double?
    var FY3                     :   Double?
    var FY2                     :   Double?
    var FY1                     :   Double?
    var Mtd                     :   Double?
    var SinceInception          :   Double?
    var FundName                :   String?
    var FundGroup               :   String?
    var ExitLoad                :   String?
    var EntryLoad               :   String?
    var DateOfInception         :   String?
    var Benchmark               :   String?
    var isExpandable            :   Bool = false
    var FundCategory            :   String?
    var fund                    :   String?
    var RiskLevel               :   String?
    var FundSize                :   String?
    var sort                    :   Int?
    
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        Serial                      <- map["Serial"]
        SFID                        <- map["SFID"]
        WhoShouldInvest             <- map["WhoShouldInvest"]
        PayoutPolicy                <- map["PayoutPolicy"]
        Objective                   <- map["Objective"]
        MinimumInvestmentAmount     <- map["MinimumInvestmentAmount"]
        ManagementFee               <- map["ManagementFee"]
        LockInPeriod                <- map["LockInPeriod"]
        KeyBenefits                 <- map["KeyBenefits"]
        InvestorRiskProfile         <- map["InvestorRiskProfile"]
        FYTD                        <- map["FYTD"]
        FY4                         <- map["FY4"]
        FY3                         <- map["FY3"]
        FY2                         <- map["FY2"]
        FY1                         <- map["FY1"]
        FundName                    <- map["FundName"]
        FundGroup                   <- map["FundGroup"]
        ExitLoad                    <- map["ExitLoad"]
        EntryLoad                   <- map["EntryLoad"]
        DateOfInception             <- map["DateOfInception"]
        Benchmark                   <- map["Benchmark"]
        SinceInception              <- map["SinceInception"]
        Mtd                         <- map["Mtd"]
        FundCategory                <- map["FundCategory"]
        fund                        <- map["Fund"]
        RiskLevel                   <- map["RiskLevel"]
        FundSize                    <- map["FundSize"]
        sort                        <- map["sort"]
    }
}
