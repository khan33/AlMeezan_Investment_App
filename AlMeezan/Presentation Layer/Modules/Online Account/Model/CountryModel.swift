//
//  CountryModel.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct CountryModel : Codable {
	let country : [Country]?
	let city : [CityModel]?

	enum CodingKeys: String, CodingKey {

		case country = "Country"
		case city = "City"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		country = try values.decodeIfPresent([Country].self, forKey: .country)
		city = try values.decodeIfPresent([CityModel].self, forKey: .city)
	}

}
