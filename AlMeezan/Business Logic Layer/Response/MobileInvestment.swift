//
//  MobileInvestment.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//
import Foundation
struct MobileInvestment : Codable {
	let customerID : String?
	let referenceID : String?
	let expiryDate : String?

	enum CodingKeys: String, CodingKey {

		case customerID = "CustomerID"
		case referenceID = "ReferenceID"
		case expiryDate = "ExpiryDate"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerID = try values.decodeIfPresent(String.self, forKey: .customerID)
		referenceID = try values.decodeIfPresent(String.self, forKey: .referenceID)
		expiryDate = try values.decodeIfPresent(String.self, forKey: .expiryDate)
	}

}
