//
//  OTPVerification.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct OTPVerification : Codable {
	let errID               : String?
    let FullName            : String?
    let FatherHusbandName   : String?
    let Gender              : String?
    let Country             : String?
    let Dob                 : String?
    let CNIC                : String?
    let CnicIssueDate       : String?
    let CnicExpireDate      : String?
    let City                : String?
    let Occupation          : String?
    let SourceofFund        : String?
    let Adders              : String?
    let Mobile              : String?
    let Email               : String?
    let BankName            : String?
    let BankAccNo           : String?
    let BankBranch          : String?
    let BankCity            : String?
    let Age                 : String?


	enum CodingKeys: String, CodingKey {

		case errID = "ErrID"
        case FullName = "FullName"
        case FatherHusbandName = "FatherHusbandName"
        case Gender = "Gender"
        case Country = "Country"
        case Dob = "Dob"
        case CNIC = "CNIC"
        case CnicIssueDate = "CnicIssueDate"
        case CnicExpireDate = "CnicExpireDate"
        case City = "City"
        case Occupation = "Occupation"
        case SourceofFund = "SourceofFund"
        case Adders = "Adders"
        case Mobile = "Mobile"
        case Email = "Email"
        case BankName = "BankName"
        case BankAccNo = "BankAccNo"
        case BankBranch = "BankBranch"
        case BankCity = "BankCity"
        case Age = "Age"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        errID = try values.decodeIfPresent(String.self, forKey: .errID)
        FullName = try values.decodeIfPresent(String.self, forKey: .FullName)
        FatherHusbandName = try values.decodeIfPresent(String.self, forKey: .FatherHusbandName)
        Dob = try values.decodeIfPresent(String.self, forKey: .Dob)
        Country = try values.decodeIfPresent(String.self, forKey: .Country)
        Gender = try values.decodeIfPresent(String.self, forKey: .Gender)
        CNIC = try values.decodeIfPresent(String.self, forKey: .CNIC)
        CnicIssueDate = try values.decodeIfPresent(String.self, forKey: .CnicIssueDate)
        CnicExpireDate = try values.decodeIfPresent(String.self, forKey: .CnicExpireDate)
        City = try values.decodeIfPresent(String.self, forKey: .City)
        Occupation = try values.decodeIfPresent(String.self, forKey: .Occupation)
        SourceofFund = try values.decodeIfPresent(String.self, forKey: .SourceofFund)
        Adders = try values.decodeIfPresent(String.self, forKey: .Adders)
        Mobile = try values.decodeIfPresent(String.self, forKey: .Mobile)
        Email = try values.decodeIfPresent(String.self, forKey: .Email)
        BankName = try values.decodeIfPresent(String.self, forKey: .BankName)
        BankAccNo = try values.decodeIfPresent(String.self, forKey: .BankAccNo)
        BankBranch = try values.decodeIfPresent(String.self, forKey: .BankBranch)
        BankCity = try values.decodeIfPresent(String.self, forKey: .BankCity)
        Age = try values.decodeIfPresent(String.self, forKey: .Age)
	}

}
