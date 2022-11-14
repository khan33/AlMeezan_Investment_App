//
//  PSXIndixesModel.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct PSXIndixesModel : Codable {
	let symbol : String?
	let currentIndex : Double?
	let high : Double?
	let low : Double?
	let netChange : Double?
	let pNetChange : Double?
	let volume : Double?
	let value : Double?
	let previousIndex : Double?
	let dayMax : Double?
	let dayMin : Double?
	let monthMax : Double?
	let monthMin : Double?
    let status  :  IndicesStatus?
    var isExpandable: Bool = false
    
	var trend : [PSXIndixesTrend]?
    var trendWeekly: [PSXIndixesTrend]?
    var trendQuarterly: [PSXIndixesTrend]?
    var trendDaily: [PSXIndixesTrend]?
    var trendMonthly: [PSXIndixesTrend]?
    
	enum CodingKeys: String, CodingKey {

		case symbol = "Symbol"
		case currentIndex = "CurrentIndex"
		case high = "High"
		case low = "Low"
		case netChange = "NetChange"
		case pNetChange = "PNetChange"
		case volume = "Volume"
		case value = "Value"
		case previousIndex = "PreviousIndex"
		case dayMax = "DayMax"
		case dayMin = "DayMin"
		case monthMax = "MonthMax"
		case monthMin = "MonthMin"
        case status = "Status"
		case trend = "Trend"
        case trendWeekly = "TrendWeekly"
        case trendQuarterly = "TrendQuarterly"
        case trendDaily = "TrendDaily"
        case trendMonthly = "TrendMonthly"
        case isExpandable = "isExpandable"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
		currentIndex = try values.decodeIfPresent(Double.self, forKey: .currentIndex)
		high = try values.decodeIfPresent(Double.self, forKey: .high)
		low = try values.decodeIfPresent(Double.self, forKey: .low)
		netChange = try values.decodeIfPresent(Double.self, forKey: .netChange)
		pNetChange = try values.decodeIfPresent(Double.self, forKey: .pNetChange)
		volume = try values.decodeIfPresent(Double.self, forKey: .volume)
		value = try values.decodeIfPresent(Double.self, forKey: .value)
		previousIndex = try values.decodeIfPresent(Double.self, forKey: .previousIndex)
		dayMax = try values.decodeIfPresent(Double.self, forKey: .dayMax)
		dayMin = try values.decodeIfPresent(Double.self, forKey: .dayMin)
		monthMax = try values.decodeIfPresent(Double.self, forKey: .monthMax)
		monthMin = try values.decodeIfPresent(Double.self, forKey: .monthMin)
        status = try values.decodeIfPresent(IndicesStatus.self, forKey: .status)
		trend = try values.decodeIfPresent([PSXIndixesTrend].self, forKey: .trend)
        trendWeekly = try values.decodeIfPresent([PSXIndixesTrend].self, forKey: .trendWeekly)
        trendQuarterly = try values.decodeIfPresent([PSXIndixesTrend].self, forKey: .trendQuarterly)
        trendDaily = try values.decodeIfPresent([PSXIndixesTrend].self, forKey: .trendDaily)
        trendMonthly = try values.decodeIfPresent([PSXIndixesTrend].self, forKey: .trendMonthly)
	}

}
