//
//  ComplaintModel.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//
import Foundation
struct ComplaintModel : Codable {
	let complaint_Number : String?
	let account_ID : String?
	let status : String?
	let createdOn : String?
	let resolveDate : String?
	let tAT : String?
	let customerNumber : String?
	let type : String?
	let subType : String?
    var isExpandable: Bool = false
	enum CodingKeys: String, CodingKey {

		case complaint_Number = "Complaint_Number"
		case account_ID = "Account_ID"
		case status = "Status"
		case createdOn = "CreatedOn"
		case resolveDate = "ResolveDate"
		case tAT = "TAT"
		case customerNumber = "CustomerNumber"
		case type = "Type"
		case subType = "SubType"
        case isExpandable = "isExpandable"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		complaint_Number = try values.decodeIfPresent(String.self, forKey: .complaint_Number)
		account_ID = try values.decodeIfPresent(String.self, forKey: .account_ID)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn)
		resolveDate = try values.decodeIfPresent(String.self, forKey: .resolveDate)
		tAT = try values.decodeIfPresent(String.self, forKey: .tAT)
		customerNumber = try values.decodeIfPresent(String.self, forKey: .customerNumber)
		type = try values.decodeIfPresent(String.self, forKey: .type)
		subType = try values.decodeIfPresent(String.self, forKey: .subType)
	}

}
