//
//  ComplainDescriptionModel.swift
//  AlMeezan
//
//  Created by Atta khan on 10/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct ComplainDescriptionModel : Codable {
    let complaint_Number : String?
    let status : String?
    let createdOn : String?
    let resolveDate : String?
    let tAT : String?
    let customerNumber : String?
    let accountNumber : String?
    let descriptionStr : String?
    let resolutionComment : String?
    let type : String?
    let subType : String?

    enum CodingKeys: String, CodingKey {

        case complaint_Number = "Complaint_Number"
        case status = "Status"
        case createdOn = "CreatedOn"
        case resolveDate = "ResolveDate"
        case tAT = "TAT"
        case customerNumber = "CustomerNumber"
        case accountNumber = "AccountNumber"
        case descriptionStr = "Description"
        case resolutionComment = "ResolutionComment"
        case type = "Type"
        case subType = "SubType"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        complaint_Number = try values.decodeIfPresent(String.self, forKey: .complaint_Number)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        createdOn = try values.decodeIfPresent(String.self, forKey: .createdOn)
        resolveDate = try values.decodeIfPresent(String.self, forKey: .resolveDate)
        tAT = try values.decodeIfPresent(String.self, forKey: .tAT)
        customerNumber = try values.decodeIfPresent(String.self, forKey: .customerNumber)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        descriptionStr = try values.decodeIfPresent(String.self, forKey: .descriptionStr)
        resolutionComment = try values.decodeIfPresent(String.self, forKey: .resolutionComment)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        subType = try values.decodeIfPresent(String.self, forKey: .subType)
    }

}
