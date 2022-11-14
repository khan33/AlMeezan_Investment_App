//
//  RiskProfileEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 25/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

enum RiskProfileEntity {
    // MARK: - Request Body ENCRYPTION
        struct RiskProfileRequest: Codable {
            var ageInYears  :   Int?
            var age :   String?
            var riskReturn  :   String?
            var monthlySavings :   String?
            var occupation  :   String?
            var investmentObjective :String?
            var knowledgeLevel  :   String?
            var investmentHorizon :   String?

            enum CodingKeys: String, CodingKey {
                case ageInYears = "AgeInYears"
                case age = "Age"
                case riskReturn = "RiskReturn"
                case monthlySavings = "MonthlySavings"
                case occupation = "Occupation"
                case investmentObjective = "InvestmentObjective"
                case knowledgeLevel = "KnowledgeLevel"
                case investmentHorizon = "InvestmentHorizon"
            }
        }
        
    // MARK: - OTP Generate Request Model
        class RiskProfileRequestModel : RequestModel {
            private var KeyValue: String
            
            init(KeyValue: String) {
                self.KeyValue = KeyValue
            }
            
            override var path: String {
                return Constant.ServiceConstant.RISK_PROFILE
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
    
    
    struct RiskProfileResponseModel : Codable {
        let idealFund : String?
        let idealPortfolio : String?
        let idealScore : Int?
        let description : String?

        enum CodingKeys: String, CodingKey {

            case idealFund = "IdealFund"
            case idealPortfolio = "IdealPortfolio"
            case idealScore = "IdealScore"
            case description = "Description"
        }

    }
}
