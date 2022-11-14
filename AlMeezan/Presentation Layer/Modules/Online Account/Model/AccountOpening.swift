//
//  Country.swift
//  AlMeezan
//
//  Created by Atta khan on 23/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct AccountOpening : Codable {
	let errID : String?
	let errMsg : String?

	enum CodingKeys: String, CodingKey {

		case errID = "ErrID"
		case errMsg = "ErrMsg"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		errID = try values.decodeIfPresent(String.self, forKey: .errID)
		errMsg = try values.decodeIfPresent(String.self, forKey: .errMsg)
	}

}
