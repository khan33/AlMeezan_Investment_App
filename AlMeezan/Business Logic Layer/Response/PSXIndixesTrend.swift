//
//  PSXIndixesTrend.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct PSXIndixesTrend: Codable {
	let symbol : String?
	let currentIndex : Double?
	let entrydatetime : String?
    var isDayTrend: Bool = false
	enum CodingKeys: String, CodingKey {

		case symbol = "Symbol"
		case currentIndex = "CurrentIndex"
		case entrydatetime = "entrydatetime"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
		currentIndex = try values.decodeIfPresent(Double.self, forKey: .currentIndex)
		entrydatetime = try values.decodeIfPresent(String.self, forKey: .entrydatetime)
	}

}
