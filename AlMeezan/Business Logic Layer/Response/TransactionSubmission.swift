//
//  TransactionSubmission.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct TransactionSubmission : Codable {
	let iD : String?
	let orderDatetime : String?
	enum CodingKeys: String, CodingKey {

		case iD = "ID"
		case orderDatetime = "OrderDatetime"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		iD = try values.decodeIfPresent(String.self, forKey: .iD)
		orderDatetime = try values.decodeIfPresent(String.self, forKey: .orderDatetime)
	}

}
