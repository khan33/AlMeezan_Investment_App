//
//  AccountOpeningFunds.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct AccountOpeningFunds : Codable {
	let fundID : String?
	let agentID : String?
	let fundName : String?
	let category : String?
	let ord : String?
	let type : String?
	let isHighRisk : Int?

	enum CodingKeys: String, CodingKey {

		case fundID = "FundID"
		case agentID = "AgentID"
		case fundName = "FundName"
		case category = "Category"
		case ord = "Ord"
		case type = "Type"
		case isHighRisk = "IsHighRisk"
	}

	

}
