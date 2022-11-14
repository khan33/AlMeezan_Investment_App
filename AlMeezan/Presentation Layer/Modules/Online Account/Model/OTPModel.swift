//
//  OTPModel.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct OTPModel : Codable {
	let errID : String?
	let sMSPin : String?
	let emailPin : String?

	enum CodingKeys: String, CodingKey {

		case errID = "ErrID"
		case sMSPin = "SMSPin"
		case emailPin = "EmailPin"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		errID = try values.decodeIfPresent(String.self, forKey: .errID)
		sMSPin = try values.decodeIfPresent(String.self, forKey: .sMSPin)
		emailPin = try values.decodeIfPresent(String.self, forKey: .emailPin)
	}

}
