//
//  TransactionDetail.swift
//  AlMeezan
//
//  Created by Atta khan on 02/07/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//


import Foundation
struct BankList : Codable {
    let BankID: String?
	let bankName : String?

	enum CodingKeys: String, CodingKey {
        case BankID = "BankID"
		case bankName = "BankName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        BankID = try values.decodeIfPresent(String.self, forKey: .BankID)
		bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
	}

}
