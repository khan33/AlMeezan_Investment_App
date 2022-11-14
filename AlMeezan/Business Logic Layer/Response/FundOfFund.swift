//
//  FundOfFund.swift
//  AlMeezan
//
//  Created by Atta khan on 27/12/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//
//

import Foundation

struct FundOfFund :  Codable {
    let serial : Int?
    let description : String?
    let whoShouldInvest : String?
    let keyBenefits : String?
    let investorRiskProfile : String?
    let maturedInvestmentPlans : String?
    let fundCategory : String?
    let fundName : String?
    let launchDate : String?
    let managementFee : String?
    let frontEndLoad : String?
    let backEndLoad : String?
    let maturityDate : String?
    let extendedMaturityDate : String?
    let tenure : String?
    let cumulativeReturn : String?
    let cumulativeBenchmarkReturn : String?
    let annualizedReturns : String?
    let benchmarkAnnualizedReturns : String?
    let uniqueBenefit : String?
    var isExpanded: Bool = false
    enum CodingKeys: String, CodingKey {

        case serial = "Serial"
        case description = "Description"
        case whoShouldInvest = "WhoShouldInvest"
        case keyBenefits = "KeyBenefits"
        case investorRiskProfile = "InvestorRiskProfile"
        case maturedInvestmentPlans = "MaturedInvestmentPlans"
        case fundCategory = "FundCategory"
        case fundName = "FundName"
        case launchDate = "LaunchDate"
        case managementFee = "ManagementFee"
        case frontEndLoad = "FrontEndLoad"
        case backEndLoad = "BackEndLoad"
        case maturityDate = "MaturityDate"
        case extendedMaturityDate = "ExtendedMaturityDate"
        case tenure = "Tenure"
        case cumulativeReturn = "CumulativeReturn"
        case cumulativeBenchmarkReturn = "CumulativeBenchmarkReturn"
        case annualizedReturns = "AnnualizedReturns"
        case benchmarkAnnualizedReturns = "BenchmarkAnnualizedReturns"
        case uniqueBenefit = "UniqueBenefit"
        case isExpanded = "isExpandable"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        serial = try values.decodeIfPresent(Int.self, forKey: .serial)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        whoShouldInvest = try values.decodeIfPresent(String.self, forKey: .whoShouldInvest)
        keyBenefits = try values.decodeIfPresent(String.self, forKey: .keyBenefits)
        investorRiskProfile = try values.decodeIfPresent(String.self, forKey: .investorRiskProfile)
        maturedInvestmentPlans = try values.decodeIfPresent(String.self, forKey: .maturedInvestmentPlans)
        fundCategory = try values.decodeIfPresent(String.self, forKey: .fundCategory)
        fundName = try values.decodeIfPresent(String.self, forKey: .fundName)
        launchDate = try values.decodeIfPresent(String.self, forKey: .launchDate)
        managementFee = try values.decodeIfPresent(String.self, forKey: .managementFee)
        frontEndLoad = try values.decodeIfPresent(String.self, forKey: .frontEndLoad)
        backEndLoad = try values.decodeIfPresent(String.self, forKey: .backEndLoad)
        maturityDate = try values.decodeIfPresent(String.self, forKey: .maturityDate)
        extendedMaturityDate = try values.decodeIfPresent(String.self, forKey: .extendedMaturityDate)
        tenure = try values.decodeIfPresent(String.self, forKey: .tenure)
        cumulativeReturn = try values.decodeIfPresent(String.self, forKey: .cumulativeReturn)
        cumulativeBenchmarkReturn = try values.decodeIfPresent(String.self, forKey: .cumulativeBenchmarkReturn)
        annualizedReturns = try values.decodeIfPresent(String.self, forKey: .annualizedReturns)
        benchmarkAnnualizedReturns = try values.decodeIfPresent(String.self, forKey: .benchmarkAnnualizedReturns)
        uniqueBenefit = try values.decodeIfPresent(String.self, forKey: .uniqueBenefit)
    }
}
