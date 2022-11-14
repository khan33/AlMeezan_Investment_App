//
//  CommoditiesModel.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//


import Foundation

struct CommoditiesModel : Codable {
	let symbol : String?
	let open : Float?
	let high : Float?
	let low : Float?
	let close : Float?
	let dateTime : String?
	let entryDate : String?
	let range : Float?
	let diff : Float?
	let perc : Float?
	let trend : [Trend]?
    let trendWeekly : [Trend]?
    let trendQuarterly : [Trend]?
    let trendHalfYearly : [Trend]?
    let trendYearly : [Trend]?
    
	enum CodingKeys: String, CodingKey {

		case symbol = "Symbol"
		case open = "Open"
		case high = "High"
		case low = "Low"
		case close = "Close"
		case dateTime = "DateTime"
		case entryDate = "EntryDate"
		case range = "Range"
		case diff = "Diff"
		case perc = "Perc"
		case trend = "Trend"
        case trendWeekly = "TrendWeekly"
        case trendQuarterly = "TrendQuarterly"
        case trendHalfYearly = "TrendHalfYearly"
        case trendYearly = "TrendYearly"
	}
	init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        open = try values.decodeIfPresent(Float.self, forKey: .open)
        high = try values.decodeIfPresent(Float.self, forKey: .high)
        low = try values.decodeIfPresent(Float.self, forKey: .low)
        close = try values.decodeIfPresent(Float.self, forKey: .close)
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
        entryDate = try values.decodeIfPresent(String.self, forKey: .entryDate)
        range = try values.decodeIfPresent(Float.self, forKey: .range)
        diff = try values.decodeIfPresent(Float.self, forKey: .diff)
        perc = try values.decodeIfPresent(Float.self, forKey: .perc)
        trend = try values.decodeIfPresent([Trend].self, forKey: .trend)
        trendWeekly = try values.decodeIfPresent([Trend].self, forKey: .trendWeekly)
        trendQuarterly = try values.decodeIfPresent([Trend].self, forKey: .trendQuarterly)
        trendHalfYearly = try values.decodeIfPresent([Trend].self, forKey: .trendHalfYearly)
        trendYearly = try values.decodeIfPresent([Trend].self, forKey: .trendYearly)
    }
}

