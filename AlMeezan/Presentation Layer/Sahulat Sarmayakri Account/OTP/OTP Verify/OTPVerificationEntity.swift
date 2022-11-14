//
//  OTPVerificationEntity.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

enum OTPVerificationEntity {
    
// MARK: - Request Body ENCRYPTION
    struct OTPVerifyRequest: Codable {
        var customerID  :   String?  =   KeychainWrapper.standard.string(forKey: "CustomerId")
        var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")
        let cnic : String?
        let code : String?
        

        enum CodingKeys: String, CodingKey {
            case customerID = "CustomerID"
            case password = "AccessToken"
            case cnic = "Cnic"
            case code = "OTP"
        }
    }
    
// MARK: - OTP Generate Request Model
    class OTPVerificationRequestModel : RequestModel {
        private var KeyValue: String
        
        init(KeyValue: String) {
            self.KeyValue = KeyValue
        }
        
        override var path: String {
            return Constant.ServiceConstant.OTP_VERIFY
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
    
    
// MARK: - OTP Generate Response Model
    struct OTPVerificationResponseModel : Codable {
        let oTPVerification : [SSAOTPVerification]?
        let accountType : [AccountType]?
        var cNICData : SSACNICData?
        enum CodingKeys: String, CodingKey {
            case oTPVerification = "OTPVerification"
            case accountType = "AccountType"
            case cNICData = "CNICData"
        }
    }
}



struct SSACNICData: Codable {
    var basicInfo : PersonalInfoEntity.BasicInfo?
    var healthDec : HealthDec?
    var kyc : KYCModel?
    var fatca : FACTAModel?
    var crs : Crs?
    var riskProfile : RiskProfile?

    enum CodingKeys: String, CodingKey {

        case basicInfo = "basicInfo"
        case healthDec = "healthDec"
        case kyc = "kyc"
        case fatca = "fatca"
        case crs = "crs"
        case riskProfile = "riskProfile"
    }
}


class SubmissionSSARequestModel : RequestModel {
    private var KeyValue: String
    
    init(KeyValue: String) {
        self.KeyValue = KeyValue
    }
    
    override var path: String {
        return Constant.ServiceConstant.SSA_SUBMISSION
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


struct SSAOTPVerification : Codable {
    let errID : String?
    enum CodingKeys: String, CodingKey {
        case errID = "ErrID"
    }
}
struct AccountType : Codable {
    let code : String?
    let name : String?
    let desc: String?

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
        case desc = "description"
    }
}


struct BasicInfo1 : Codable {
    let fullName : String?
    let fatherHusbandName : String?
    let motherMaidenName : String?
    let cnicIssueDate : String?
    let cnicExpiryDate : String?
    let dateOfBirth : String?
    let maritalStatus : String?
    let zakatStatus : String?
    let religion : String?
    let nationality : String?
    let dualNational : String?
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
    let jointHolder : JointHolder?
    let simOwner : SimOwner?
    let daoID : String?
    let cnic : String?
    let accountType : String?

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
    let fullName : String?
    let relationship : String?
    let nic : String?
    let issueDate : String?
    let expiryDate : String?
    let cnic : String?
    let accountType : String?

    enum CodingKeys: String, CodingKey {

        case fullName = "FullName"
        case relationship = "Relationship"
        case nic = "Nic"
        case issueDate = "IssueDate"
        case expiryDate = "ExpiryDate"
        case cnic = "Cnic"
        case accountType = "AccountType"
    }
}
struct HealthDec : Codable {
    let pension : Pension1?
    let takafulQues : TakafulQues?
    let covid19Ques : Covid19Ques?
    let cnic : String?
    let accountType : String?

    enum CodingKeys: String, CodingKey {

        case pension = "pension"
        case takafulQues = "TakafulQues"
        case covid19Ques = "Covid19Ques"
        case cnic = "Cnic"
        case accountType = "AccountType"
    }
}
struct Pension1 : Codable {
    let expectedRetirementAge : Int?
    let allocationScheme : String?
    let personalPhysicianName : String?
    let employersPhoneNo : String?
    let presentOccupation : String?
    let investmentAmount : Double?
    let weight : Double?
    let height : Double?
    let cnic : String?
    let accountType : String?

    enum CodingKeys: String, CodingKey {

        case expectedRetirementAge = "ExpectedRetirementAge"
        case allocationScheme = "AllocationScheme"
        case personalPhysicianName = "PersonalPhysicianName"
        case employersPhoneNo = "EmployersPhoneNo"
        case presentOccupation = "PresentOccupation"
        case investmentAmount = "InvestmentAmount"
        case weight = "Weight"
        case height = "Height"
        case cnic = "Cnic"
        case accountType = "AccountType"
    }
}
struct TakafulQues : Codable {
    let everDiagnosedWith : EverDiagnosedWith?
    let takingMedication : TakingMedication?
    let diedOrSufferedBefore60 : DiedOrSufferedBefore60?
    let lifeInsurance : LifeInsurance?
    let doYouSmoke : DoYouSmoke?
    let drinkAlcohol : DrinkAlcohol?
    let drugsOtherThanDr : DrugsOtherThanDr?
    let hazardourPursuits : HazardourPursuits?
    let foriegnTravel : ForiegnTravel?

    enum CodingKeys: String, CodingKey {

        case everDiagnosedWith = "EverDiagnosedWith"
        case takingMedication = "TakingMedication"
        case diedOrSufferedBefore60 = "DiedOrSufferedBefore60"
        case lifeInsurance = "LifeInsurance"
        case doYouSmoke = "DoYouSmoke"
        case drinkAlcohol = "DrinkAlcohol"
        case drugsOtherThanDr = "DrugsOtherThanDr"
        case hazardourPursuits = "HazardourPursuits"
        case foriegnTravel = "ForiegnTravel"
    }
}

struct Covid19Ques : Codable {
    let fever : Int?
    let soreThroat : Int?
    let dryCough : Int?
    let bodyAche : Int?
    let headAche : Int?
    let shortnessOfBreath : Int?
    let fatigue : Int?
    let lossOfTaste : Int?
    let lossOfSmell : Int?
    let anyoneIfYesFurtherDetails : String?
    let covid19Tested : Int?
    let dateOfTest : String?
    let resultOfTest : String?
    let inCasePositiveResultCompleteRecovery : Int?
    let past14ContactedWithAnyOne : Int?
    let noticeIssueForSelfQuarantine : Int?
    let stayOutsideCountryOrReturned : Int?
    let stayOutSideCountryIfYesDetails : String?
    let nextThreeMonthsTravel : Int?
    let nextThreeMonthIfYesDetails : String?

    enum CodingKeys: String, CodingKey {

        case fever = "Fever"
        case soreThroat = "SoreThroat"
        case dryCough = "DryCough"
        case bodyAche = "BodyAche"
        case headAche = "HeadAche"
        case shortnessOfBreath = "ShortnessOfBreath"
        case fatigue = "Fatigue"
        case lossOfTaste = "LossOfTaste"
        case lossOfSmell = "LossOfSmell"
        case anyoneIfYesFurtherDetails = "AnyoneIfYesFurtherDetails"
        case covid19Tested = "Covid19Tested"
        case dateOfTest = "DateOfTest"
        case resultOfTest = "ResultOfTest"
        case inCasePositiveResultCompleteRecovery = "InCasePositiveResultCompleteRecovery"
        case past14ContactedWithAnyOne = "Past14ContactedWithAnyOne"
        case noticeIssueForSelfQuarantine = "NoticeIssueForSelfQuarantine"
        case stayOutsideCountryOrReturned = "StayOutsideCountryOrReturned"
        case stayOutSideCountryIfYesDetails = "StayOutSideCountryIfYesDetails"
        case nextThreeMonthsTravel = "NextThreeMonthsTravel"
        case nextThreeMonthIfYesDetails = "NextThreeMonthIfYesDetails"
    }
}
