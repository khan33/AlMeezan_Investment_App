//
//  OTPVerificationModel.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct OTPVerificationModel : Codable {
	let oTPVerification : [OTPVerification]?
	let cNICData : [CNICData]?

	enum CodingKeys: String, CodingKey {

		case oTPVerification = "OTPVerification"
		case cNICData = "CNICData"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		oTPVerification = try values.decodeIfPresent([OTPVerification].self, forKey: .oTPVerification)
		cNICData = try values.decodeIfPresent([CNICData].self, forKey: .cNICData)
	}

}
struct CNICData : Codable {
    let fullName : String?
    let fatherHusbandName : String?
    let gender : String?
    let country : String?
    let dob : String?
    let cNIC : String?
    let cnicIssueDate : String?
    let cnicExpiryDate : String?
    let city : String?
    let occupation : String?
    let sourceofFund : String?
    let address : String?
    let mobile : String?
    let email : String?
    let bankName : String?
    let bankAccNo : String?
    let bankBranch : String?
    let bankCity : String?
    let age : String?

    enum CodingKeys: String, CodingKey {

        case fullName = "FullName"
        case fatherHusbandName = "FatherHusbandName"
        case gender = "Gender"
        case country = "Country"
        case dob = "Dob"
        case cNIC = "CNIC"
        case cnicIssueDate = "CnicIssueDate"
        case cnicExpiryDate = "CnicExpiryDate"
        case city = "City"
        case occupation = "Occupation"
        case sourceofFund = "SourceofFund"
        case address = "Address"
        case mobile = "Mobile"
        case email = "Email"
        case bankName = "BankName"
        case bankAccNo = "BankAccNo"
        case bankBranch = "BankBranch"
        case bankCity = "BankCity"
        case age = "Age"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        fatherHusbandName = try values.decodeIfPresent(String.self, forKey: .fatherHusbandName)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        dob = try values.decodeIfPresent(String.self, forKey: .dob)
        cNIC = try values.decodeIfPresent(String.self, forKey: .cNIC)
        cnicIssueDate = try values.decodeIfPresent(String.self, forKey: .cnicIssueDate)
        cnicExpiryDate = try values.decodeIfPresent(String.self, forKey: .cnicExpiryDate)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        occupation = try values.decodeIfPresent(String.self, forKey: .occupation)
        sourceofFund = try values.decodeIfPresent(String.self, forKey: .sourceofFund)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
        bankAccNo = try values.decodeIfPresent(String.self, forKey: .bankAccNo)
        bankBranch = try values.decodeIfPresent(String.self, forKey: .bankBranch)
        bankCity = try values.decodeIfPresent(String.self, forKey: .bankCity)
        age = try values.decodeIfPresent(String.self, forKey: .age)
    }

}
