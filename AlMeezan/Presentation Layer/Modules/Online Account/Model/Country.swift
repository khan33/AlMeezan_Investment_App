//
//  Country.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct Country : Codable {
	let cOUNTRY_DIAL_CODE : String?
	let cOUNTRY_SHORT_NAME : String?
	let cOUNTRY : String?

	enum CodingKeys: String, CodingKey {

		case cOUNTRY_DIAL_CODE = "COUNTRY_DIAL_CODE"
		case cOUNTRY_SHORT_NAME = "COUNTRY_SHORT_NAME"
		case cOUNTRY = "COUNTRY"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		cOUNTRY_DIAL_CODE = try values.decodeIfPresent(String.self, forKey: .cOUNTRY_DIAL_CODE)
		cOUNTRY_SHORT_NAME = try values.decodeIfPresent(String.self, forKey: .cOUNTRY_SHORT_NAME)
		cOUNTRY = try values.decodeIfPresent(String.self, forKey: .cOUNTRY)
	}

}
