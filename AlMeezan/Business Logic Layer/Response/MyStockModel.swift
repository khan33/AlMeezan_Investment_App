//
//  MyStockModel.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation

struct MyStockModel : Codable {
	let symbol : String?
	let sector : String?
	let marketCode : String?
	let marketStatus : String?
	let last : Double?
	let lastTradeVolume : Double?
	let bid : Double?
	let bidVolume : Double?
	let ask : Double?
	let askVolume : Double?
	let high : Double?
	let low : Double?
	let netChange : Double?
	let open : Double?
	let lDCP : Double?
	let averagePrice : Double?
	let volume : Double?
	let totalTrades : Double?
	let direction : String?
	let datetime : String?
	let entrydatetime : String?
    let changePerc: Double?
	enum CodingKeys: String, CodingKey {

		case symbol = "Symbol"
		case sector = "Sector"
		case marketCode = "MarketCode"
		case marketStatus = "MarketStatus"
		case last = "Last"
		case lastTradeVolume = "LastTradeVolume"
		case bid = "Bid"
		case bidVolume = "BidVolume"
		case ask = "Ask"
		case askVolume = "AskVolume"
		case high = "High"
		case low = "Low"
		case netChange = "NetChange"
		case open = "Open"
		case lDCP = "LDCP"
		case averagePrice = "AveragePrice"
		case volume = "Volume"
		case totalTrades = "TotalTrades"
		case direction = "Direction"
		case datetime = "Datetime"
		case entrydatetime = "entrydatetime"
        case changePerc = "ChangePerc"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
		sector = try values.decodeIfPresent(String.self, forKey: .sector)
		marketCode = try values.decodeIfPresent(String.self, forKey: .marketCode)
		marketStatus = try values.decodeIfPresent(String.self, forKey: .marketStatus)
		last = try values.decodeIfPresent(Double.self, forKey: .last)
		lastTradeVolume = try values.decodeIfPresent(Double.self, forKey: .lastTradeVolume)
		bid = try values.decodeIfPresent(Double.self, forKey: .bid)
		bidVolume = try values.decodeIfPresent(Double.self, forKey: .bidVolume)
		ask = try values.decodeIfPresent(Double.self, forKey: .ask)
		askVolume = try values.decodeIfPresent(Double.self, forKey: .askVolume)
		high = try values.decodeIfPresent(Double.self, forKey: .high)
		low = try values.decodeIfPresent(Double.self, forKey: .low)
		netChange = try values.decodeIfPresent(Double.self, forKey: .netChange)
		open = try values.decodeIfPresent(Double.self, forKey: .open)
		lDCP = try values.decodeIfPresent(Double.self, forKey: .lDCP)
		averagePrice = try values.decodeIfPresent(Double.self, forKey: .averagePrice)
		volume = try values.decodeIfPresent(Double.self, forKey: .volume)
		totalTrades = try values.decodeIfPresent(Double.self, forKey: .totalTrades)
		direction = try values.decodeIfPresent(String.self, forKey: .direction)
		datetime = try values.decodeIfPresent(String.self, forKey: .datetime)
		entrydatetime = try values.decodeIfPresent(String.self, forKey: .entrydatetime)
        changePerc = try values.decodeIfPresent(Double.self, forKey: .changePerc)
	}

}
