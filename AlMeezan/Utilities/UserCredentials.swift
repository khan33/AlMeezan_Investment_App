//
//  UserCredentials.swift
//  AlMeezan
//
//  Created by Atta khan on 25/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class UserCredentials: Codable {
    var CustomerID  =   ""
    var AccessToken =   ""
    var Date        =   ""
    var Stock       =   ""
    
    
    func encodeParams(_ data: UserCredentials) -> String {
        let encode = JSONEncoder()
        let jsonData = try! encode.encode(data)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        return jsonString
    }
}
