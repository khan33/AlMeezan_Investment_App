//
//  OccupationModel.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct OccupationModel : Codable {
	let occupation : [Occupation]?
	let sourceOfFund : [SourceOfFund]?

	enum CodingKeys: String, CodingKey {

		case occupation = "Occupation"
		case sourceOfFund = "SourceOfFund"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		occupation = try values.decodeIfPresent([Occupation].self, forKey: .occupation)
		sourceOfFund = try values.decodeIfPresent([SourceOfFund].self, forKey: .sourceOfFund)
	}

}
