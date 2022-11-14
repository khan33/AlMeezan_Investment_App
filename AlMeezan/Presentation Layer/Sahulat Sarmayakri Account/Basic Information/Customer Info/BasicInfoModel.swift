//
//  BasicInfoModel.swift
//  AlMeezan
//
//  Created by Atta khan on 18/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

struct CustomerInfo: Codable {
    let CNIC: String?
    let email: String?
    let mobileNO: String?
    let simOwner: String?
    let simOwnerCode: String?
}

struct BasicInfoModel: Codable {
    let name    : String?
    let fName   : String?
    let MName   : String?
    let CNIC    : String?
    let CNICIssueDate: String?
    let CNICExpiryDate: String?
    let lifeTimeCNICValid: String?
    let maritalStatus: String?
    let nationality: String?
    let dualNationality: String?
    let residentialStatus: String?
    let religious: String?
    let isZakatExemption: String?
}


struct PensionFundModel: Codable {
    let expectedRetirementAge: String?
    let expectedInvestmentAmount: String?
    let annualIncome: String?
    let allocationScheme: String?
}


struct ContactDetailsModel: Codable {
    let phoneNumber: String?
    let mobileNumber: String?
    let officeNumber: String?
    let emailAddress: String?
    let currentAddress: String?
    let permentAddress: String?
    let isSameCurrentAddress: Bool?
    let currentCountry: String?
    let permanentCountry: String?
}


struct BankDetailsModel : Codable {
    let bankName: String?
    let branchName: String?
    let branchCity: String?
    let IBAN_Number: String?
    let cashDividend: String?
    let stockDividend: String?
    let kinName: String?
    let kinContactNumber: String?
    let kinAddress: String?
    let relationshipWithPrincipal: String?
}

