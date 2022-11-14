//
//  EasyCashModel.swift
//  AlMeezan
//
//  Created by Atta khan on 9/09/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//


import Foundation
struct SukukModel : Codable {
	let description : String?
	let couponRate : Double?
	let issueDate : String?
	let maturityDate : String?
	let nextReset : String?
	let yield : Double?
	let timeStamp : String?

	enum CodingKeys: String, CodingKey {

		case description = "Description"
		case couponRate = "CouponRate"
		case issueDate = "IssueDate"
		case maturityDate = "MaturityDate"
		case nextReset = "NextReset"
		case yield = "Yield"
		case timeStamp = "TimeStamp"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		couponRate = try values.decodeIfPresent(Double.self, forKey: .couponRate)
		issueDate = try values.decodeIfPresent(String.self, forKey: .issueDate)
		maturityDate = try values.decodeIfPresent(String.self, forKey: .maturityDate)
		nextReset = try values.decodeIfPresent(String.self, forKey: .nextReset)
		yield = try values.decodeIfPresent(Double.self, forKey: .yield)
		timeStamp = try values.decodeIfPresent(String.self, forKey: .timeStamp)
	}
    
}
