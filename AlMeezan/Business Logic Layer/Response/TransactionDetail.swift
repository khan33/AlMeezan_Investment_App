//
//  TransactionDetail.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct TransactionDetail : Codable {
	let portfolioiD : String?
	let dealdate : String?
	let fundid : String?
	let mnumenic : String?
	let transDesc : String?
	let units : Double?
	let nav : Double?
	let amount : Double?
	let saleLoad : Double?
	let cGT : Double?
	let zakatAmount : Double?
	let fED_SST : Double?

	enum CodingKeys: String, CodingKey {

		case portfolioiD = "PortfolioiD"
		case dealdate = "dealdate"
		case fundid = "fundid"
		case mnumenic = "mnumenic"
		case transDesc = "TransDesc"
		case units = "Units"
		case nav = "Nav"
		case amount = "Amount"
		case saleLoad = "SaleLoad"
		case cGT = "CGT"
		case zakatAmount = "ZakatAmount"
		case fED_SST = "FED_SST"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		portfolioiD = try values.decodeIfPresent(String.self, forKey: .portfolioiD)
		dealdate = try values.decodeIfPresent(String.self, forKey: .dealdate)
		fundid = try values.decodeIfPresent(String.self, forKey: .fundid)
		mnumenic = try values.decodeIfPresent(String.self, forKey: .mnumenic)
		transDesc = try values.decodeIfPresent(String.self, forKey: .transDesc)
		units = try values.decodeIfPresent(Double.self, forKey: .units)
		nav = try values.decodeIfPresent(Double.self, forKey: .nav)
		amount = try values.decodeIfPresent(Double.self, forKey: .amount)
		saleLoad = try values.decodeIfPresent(Double.self, forKey: .saleLoad)
		cGT = try values.decodeIfPresent(Double.self, forKey: .cGT)
		zakatAmount = try values.decodeIfPresent(Double.self, forKey: .zakatAmount)
		fED_SST = try values.decodeIfPresent(Double.self, forKey: .fED_SST)
	}

}
