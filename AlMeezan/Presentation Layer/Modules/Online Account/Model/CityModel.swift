//
//  City.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct CityModel : Codable {
	let dIALCODE : String?
	let cITY : String?
	let cITYCODE : String?

	enum CodingKeys: String, CodingKey {

		case dIALCODE = "DIALCODE"
		case cITY = "CITY"
		case cITYCODE = "CITYCODE"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dIALCODE = try values.decodeIfPresent(String.self, forKey: .dIALCODE)
		cITY = try values.decodeIfPresent(String.self, forKey: .cITY)
		cITYCODE = try values.decodeIfPresent(String.self, forKey: .cITYCODE)
	}

}
