//
//  EasyCashModel.swift
//  AlMeezan
//
//  Created by Atta khan on 28/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
struct EasyCashModel : Codable {
    let errID : String?
    let text : String?

    enum CodingKeys: String, CodingKey {

        case errID = "ErrID"
        case text = "Text"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errID = try values.decodeIfPresent(String.self, forKey: .errID)
        text = try values.decodeIfPresent(String.self, forKey: .text)
    }

}


struct VpsRedemptionModel: Codable {
    let portfolio_ID : String?
    let description : String?
    let fundID : String?
    let aGENT_ID : String?
    let aGENT_NAME : String?
    let isTaxabale : Bool?
    let bal : Double?

    enum CodingKeys: String, CodingKey {

        case portfolio_ID = "Portfolio_ID"
        case description = "description"
        case fundID = "FundID"
        case aGENT_ID = "AGENT_ID"
        case aGENT_NAME = "AGENT_NAME"
        case isTaxabale = "isTaxabale"
        case bal = "Bal"
    }
    
    
}


struct VpsTaxDocument: Codable {
    let key, label: String?
    let yearList: String?
    var isExpandable: Bool = false

    enum CodingKeys: String, CodingKey {
        case key = "Key"
        case label = "Label"
        case yearList = "YearList"
    }
}
