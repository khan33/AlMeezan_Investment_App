//
//  BiometricResponse.swift
//  AlMeezan
//
//  Created by Atta khan on 03/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//


import Foundation
class BiometricResponse : NSObject, Codable {
	let errID : String?
	let userID : String?
	let passToken : String?
	let message : String?

	enum CodingKeys: String, CodingKey {

		case errID = "ErrID"
		case userID = "UserID"
		case passToken = "PassToken"
		case message = "Message"
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		errID = try values.decodeIfPresent(String.self, forKey: .errID)
		userID = try values.decodeIfPresent(String.self, forKey: .userID)
		passToken = try values.decodeIfPresent(String.self, forKey: .passToken)
		message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}
