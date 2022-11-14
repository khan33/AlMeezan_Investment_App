//
//  Trend.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation

struct Trend : Codable {
	let close : Float?
	let date : String?
	enum CodingKeys: String, CodingKey {
		case close = "Close"
		case date = "Date"
	}
    
    // MARK: - Decodable
	init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        close = try values.decodeIfPresent(Float.self, forKey: .close)
        date = try values.decodeIfPresent(String.self, forKey: .date)
    }
}
