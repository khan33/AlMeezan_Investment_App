//
//  ActiveCompanies.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct ActiveCompanies : Codable {
	let symbol : String?
	let volume : Double?
	let entrydatetime : String?
    let index: String?
    let price: Double?
    let netChange: Double?
    let changePerc: Double?
    let sector: String?
	enum CodingKeys: String, CodingKey {
		case symbol = "Symbol"
		case volume = "Volume"
		case entrydatetime = "entrydatetime"
        case index  =   "Index"
        case price  =   "Price"
        case netChange  =   "NetChange"
        case changePerc =   "ChangePerc"
        case sector     =   "Sector"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
		volume = try values.decodeIfPresent(Double.self, forKey: .volume)
        price = try values.decodeIfPresent(Double.self, forKey: .price)
        netChange = try values.decodeIfPresent(Double.self, forKey: .netChange)
        changePerc = try values.decodeIfPresent(Double.self, forKey: .changePerc)
		entrydatetime = try values.decodeIfPresent(String.self, forKey: .entrydatetime)
        index = try values.decodeIfPresent(String.self, forKey: .index)
        sector = try values.decodeIfPresent(String.self, forKey: .sector)
	}

}
