//
//  SetupModel.swift
//  AlMeezan
//
//  Created by Atta khan on 23/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


struct SetupModel : Codable {
    
    let simOwner : [OptionModel]?
    let nationality : [OptionModel]?
    let residentialStatus : [OptionModel]?
    let religion : [OptionModel]?
    let maritalStatus : [OptionModel]?
    let relationship : [OptionModel]?
    let allocationScheme : [OptionModel]?
    let presentOccupation : [OptionModel]?
    let healthQuestionnaire : HealthQuestionnaire?
    let covidQuestionnaire : HealthQuestionnaire?
    let covid19Questionnaire : HealthQuestionnaire?
    let sourceOfIncome : [OptionModel]?
    let sourceOfWealth : [OptionModel]?
    let pEP : [OptionModel]?
    let whereDidYouHere : [OptionModel]?
    let fatcaQuestions : [OptionModel]?
    let age : [OptionModel]?
    let riskTolerence : [OptionModel]?
    let monthlySavings : [OptionModel]?
    let occupation : [OptionModel]?
    let investmentObjective : [OptionModel]?
    let knowledgeOfInvestment : [OptionModel]?
    let investmentHorizon : [OptionModel]?
    let riskDisclaimer : [OptionModel]?
    let disclaimer : [OptionModel]?
    let investmentCharges: [InvestmentCharges]?
    let profession: [OptionModel]?
    let education: [OptionModel]?
    let geographyDomestic: [OptionModel]?
    let geographyInternational: [OptionModel]?
    
    
    
    
    enum CodingKeys: String, CodingKey {

        case simOwner = "SimOwner"
        case nationality = "Nationality"
        case residentialStatus = "ResidentialStatus"
        case religion = "Religion"
        case maritalStatus = "MaritalStatus"
        case relationship = "Relationship"
        case allocationScheme = "AllocationScheme"
        case presentOccupation = "PresentOccupation"
        case healthQuestionnaire = "HealthQuestionnaire"
        case covidQuestionnaire = "CovidQuestionnaire"
        case covid19Questionnaire = "Covid19Questions"
        case sourceOfIncome = "SourceOfIncome"
        case sourceOfWealth = "SourceOfWealth"
        case pEP = "PEP"
        case whereDidYouHere = "WhereDidYouHere"
        case fatcaQuestions = "FatcaQuestions"
        case age = "Age"
        case riskTolerence = "RiskTolerence"
        case monthlySavings = "MonthlySavings"
        case occupation = "Occupation"
        case investmentObjective = "InvestmentObjective"
        case knowledgeOfInvestment = "KnowledgeOfInvestment"
        case investmentHorizon = "InvestmentHorizon"
        case riskDisclaimer = "RiskDisclaimer"
        case disclaimer = "Disclaimer"
        case investmentCharges = "InvestmentCharges"
        case profession = "Profession"
        case education = "Education"
        case geographyDomestic = "GeographyDomestic"
        case geographyInternational = "GeographyInternational"
    }

    

}

struct InvestmentCharges: Codable {
    let min : Int?
    let max : Int?
    let charges: Int?

    enum CodingKeys: String, CodingKey {
        case min = "Min"
        case max = "Max"
        case charges = "Charges"
    }
}

struct OptionModel : Codable , Equatable{
    var code : String?
    let name : String?
    var isActive: Int?
    var answer: Int = 0
    var textFieldRequired: Bool? = true
    var explaination: String? = ""
    var Documents: String?
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
        case isActive = "isActive"
        case textFieldRequired = "textFieldRequired"
        case Documents = "Documents"
    }
}




class HealthQuestionnaire : NSObject, Codable {
    let question1 : String?
    let question : String?
    var q1 : [OptionModel]?
    var q2 : [OptionModel]?
    var q3 : [OptionModel]?
    var q4 : [OptionModel]?
    var q5 : [OptionModel]?
    var q6 : [OptionModel]?
    var q7 : [OptionModel]?
    var q8 : [OptionModel]?
    var q9 : [OptionModel]?
    var q10 : [OptionModel]?
    var q11 : [OptionModel]?
    var q12 : [OptionModel]?
    var q13 : [OptionModel]?
    var q14 : [OptionModel]?
    var q15 : [OptionModel]?

    enum CodingKeys: String, CodingKey {
        case question = "Question"
        case question1 = "Question1"
        case q1 = "q1"
        case q2 = "q2"
        case q3 = "q3"
        case q4 = "q4"
        case q5 = "q5"
        case q6 = "q6"
        case q7 = "q7"
        case q8 = "q8"
        case q9 = "q9"
        case q10 = "q10"
        case q11 = "q11"
        case q12 = "q12"
        case q13 = "q13"
        case q14 = "q14"
        case q15 = "q15"
    }
    
    override init() {
        question = nil
        question1 = nil
        q1 = nil
        q2 = nil
        q3 = nil
        q4 = nil
        q5 = nil
        q6 = nil
        q7 = nil
        q8 = nil
        q9 = nil
        q10 = nil
        q11 = nil
        q12 = nil
        q13 = nil
        q14 = nil
        q15 = nil
        print("in init()")
    }
}
