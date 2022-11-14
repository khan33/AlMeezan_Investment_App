//
//  CreateComplaint.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
struct CreateComplaint : Codable {
	let customerID : String?
	let complaintID : String?
	let complaintType : String?

	enum CodingKeys: String, CodingKey {

		case customerID = "CustomerID"
		case complaintID = "ComplaintID"
		case complaintType = "ComplaintType"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		customerID = try values.decodeIfPresent(String.self, forKey: .customerID)
		complaintID = try values.decodeIfPresent(String.self, forKey: .complaintID)
		complaintType = try values.decodeIfPresent(String.self, forKey: .complaintType)
	}

}
