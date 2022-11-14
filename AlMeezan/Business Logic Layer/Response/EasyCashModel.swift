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
