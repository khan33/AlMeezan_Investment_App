//
//  PersonalInfoEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 13/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum PersonalInfoEntity {
    
// MARK: - Request Body ENCRYPTION
    struct PersonalInfoRequest: Codable {
        var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
        }
    }
    
// MARK: - OTP Generate Request Model
    class PersonalInfoRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.BANK_LIST
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
    
    
// MARK: - Personal Info Response Model
    struct PersonalInfoResponseModel : Codable {
        let BankID: String?
        let bankName : String?

        enum CodingKeys: String, CodingKey {
            case BankID = "BankID"
            case bankName = "BankName"
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            BankID = try values.decodeIfPresent(String.self, forKey: .BankID)
            bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
        }
    }
    
    
    struct BasicInfo : Codable {
        let fullName : String?
        let fatherHusbandName : String?
        let motherMaidenName : String?
        let cnicIssueDate : String?
        let cnicExpiryDate : String?
        let dateOfBirth : String?
        var maritalStatus : String?
        var zakatStatus : String?
        let religion : String?
        let nationality : String?
        let dualNational : String?
        let dualNationalCountry: String?
        let residentialStatus : String?
        let phoneNo : String?
        let officeNo : String?
        let mobileNo : String?
        let mobileNetwork : String?
        let ported : String?
        let emailAddress : String?
        let currentAddress : String?
        let currentCity : String?
        let currentCountry : String?
        let permanentAddress : String?
        let permanentCity : String?
        let permanentCountry : String?
        let bankName : String?
        let bankAccountNo : String?
        let branchName : String?
        let branchCity : String?
        let cashDividend : String?
        let stockDividend : String?
        let nextOfKin : NextOfKin?
        var jointHolder : JointHolder?
        let simOwner : SimOwner?
        let daoID : String?
        let cnic : String?
        let accountType : String?
        let channel: String?
        var isJointAccount: Bool = false
        enum CodingKeys: String, CodingKey {

            case fullName = "FullName"
            case fatherHusbandName = "FatherHusbandName"
            case motherMaidenName = "MotherMaidenName"
            case cnicIssueDate = "CnicIssueDate"
            case cnicExpiryDate = "CnicExpiryDate"
            case dateOfBirth = "DateOfBirth"
            case maritalStatus = "MaritalStatus"
            case zakatStatus = "ZakatStatus"
            case religion = "Religion"
            case nationality = "Nationality"
            case dualNational = "DualNational"
            case dualNationalCountry = "DualNationalCountry"
            case residentialStatus = "ResidentialStatus"
            case phoneNo = "PhoneNo"
            case officeNo = "OfficeNo"
            case mobileNo = "MobileNo"
            case mobileNetwork = "MobileNetwork"
            case ported = "Ported"
            case emailAddress = "EmailAddress"
            case currentAddress = "CurrentAddress"
            case currentCity = "CurrentCity"
            case currentCountry = "CurrentCountry"
            case permanentAddress = "PermanentAddress"
            case permanentCity = "PermanentCity"
            case permanentCountry = "PermanentCountry"
            case bankName = "BankName"
            case bankAccountNo = "BankAccountNo"
            case branchName = "BranchName"
            case branchCity = "BranchCity"
            case cashDividend = "CashDividend"
            case stockDividend = "StockDividend"
            case nextOfKin = "nextOfKin"
            case jointHolder = "jointHolder"
            case simOwner = "simOwner"
            case daoID = "DaoID"
            case cnic = "Cnic"
            case accountType = "AccountType"
            case channel = "Channel"
        }
    }
    struct SimOwner : Codable {
        let simOwnerType : String?
        let simOwnerCnic : String?
        let cnic : String?
        let accountType : String?

        enum CodingKeys: String, CodingKey {

            case simOwnerType = "SimOwnerType"
            case simOwnerCnic = "SimOwnerCnic"
            case cnic = "Cnic"
            case accountType = "AccountType"
        }
    }
    struct JointHolder : Codable {
        var fullName : String?
        var relationship : String?
        var nic : String?
        var issueDate : String?
        var expiryDate : String?
        let cnic : String?
        let accountType: String?
        var fatca : FACTAModel?
        var crs : Crs?
        var pebDec: PEBDesModel?
        
        enum CodingKeys: String, CodingKey {
            case fullName = "FullName"
            case relationship = "Relationship"
            case nic = "Nic"
            case issueDate = "IssueDate"
            case expiryDate = "ExpiryDate"
            case cnic = "Cnic"
            case accountType = "AccountType"
            case fatca = "fatca"
            case crs = "crs"
            case pebDec = "PepDec"
        }
    }
    
    struct NextOfKin : Codable {
        let fullName : String?
        let contactNumber : String?
        let relationship : String?
        let address : String?
        let cnic : String?
        let accountType : String?

        enum CodingKeys: String, CodingKey {

            case fullName = "FullName"
            case contactNumber = "ContactNumber"
            case relationship = "Relationship"
            case address = "Address"
            case cnic = "Cnic"
            case accountType = "AccountType"
        }
    }
    struct Pension : Codable {
        let expectedRetirementAge : Int?
        let allocationScheme : String?
        let personalPhysicianName : String?
        let employersPhoneNo : String?
        let presentOccupation : String?
        let investmentAmount : Int?
        let weight : Int?
        let height : Double?

        enum CodingKeys: String, CodingKey {

            case expectedRetirementAge = "ExpectedRetirementAge"
            case allocationScheme = "AllocationScheme"
            case personalPhysicianName = "PersonalPhysicianName"
            case employersPhoneNo = "EmployersPhoneNo"
            case presentOccupation = "PresentOccupation"
            case investmentAmount = "InvestmentAmount"
            case weight = "Weight"
            case height = "Height"
        }
    }
    
    
    
}
struct PEBDesModel: Codable {
    let actionOnBehalfOfOther : Int?
    let refusedYourAccount : Int?
    let seniorPositionInGovtInstitute : Int?
    let seniorPositionInPoliticalParty : Int?
    let financiallyDependent : Int?
    let highValueGoldSilverDiamond :Int?
    let incomeIsHighRisk : Int?
    let headOfState : Int?
    let seniorMilitaryOfficer : Int?
    let headOfDeptOrIntlOrg : Int?
    let memberOfBoard : Int?
    let memberOfNationalSenate : Int?
    let politicalPartyOfficials : Int?
    enum CodingKeys: String, CodingKey {
        case actionOnBehalfOfOther = "actionOnBehalfOfOther"
        case refusedYourAccount = "refusedYourAccount"
        case seniorPositionInGovtInstitute = "seniorPositionInGovtInstitute"
        case seniorPositionInPoliticalParty = "seniorPositionInPoliticalParty"
        case financiallyDependent = "financiallyDependent"
        case highValueGoldSilverDiamond = "highValueGoldSilverDiamond"
        case incomeIsHighRisk = "incomeIsHighRisk"
        case headOfState = "headOfState"
        case seniorMilitaryOfficer = "seniorMilitaryOfficer"
        case headOfDeptOrIntlOrg = "headOfDeptOrIntlOrg"
        case memberOfBoard = "memberOfBoard"
        case memberOfNationalSenate = "memberOfNationalSenate"
        case politicalPartyOfficials = "politicalPartyOfficials"
    }
}
