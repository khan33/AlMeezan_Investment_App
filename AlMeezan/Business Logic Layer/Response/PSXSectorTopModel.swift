//
//  PSXSectorTopModel.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct PSXSectorTopModel : Codable {
	let sector : String?
	let volume : Double?
    let entrydatetime : String?
    let index: String?
	enum CodingKeys: String, CodingKey {

		case sector = "Sector"
		case volume = "Volume"
        case entrydatetime = "entrydatetime"
        case index = "Index"
	}
    
    

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		sector = try values.decodeIfPresent(String.self, forKey: .sector)
		volume = try values.decodeIfPresent(Double.self, forKey: .volume)
        entrydatetime = try values.decodeIfPresent(String.self, forKey: .entrydatetime)
        index = try values.decodeIfPresent(String.self, forKey: .index)
	}

}
