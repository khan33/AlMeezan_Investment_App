//
//  TransactionDetail.swift
//  AlMeezan
//
//  Created by Atta khan on 02/07/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct PSXCompanyIndicesModel : Codable {
	let indexes : [String]?
	enum CodingKeys: String, CodingKey {

		case indexes = "Indexes"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		indexes = try values.decodeIfPresent([String].self, forKey: .indexes)
	}

}
