//
//  NotificationList.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//


import Foundation
struct NotificationList : Codable {
    let id : Int?
	let customerID : String?
    let title : String?
    let body : String?
    let priority : String?
    let deviceID : String?
    let timeStamp : String?
    let topic : String?
    let destination : String?
    var read: Int?
    let rId: Int?

    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case customerID = "CustomerID"
        case title = "Title"
        case body = "Body"
        case priority = "Priority"
        case deviceID = "DeviceID"
        case timeStamp = "TimeStamp"
        case topic = "Topic"
        case destination = "Destination"
        case read = "Read"
        case rId = "RID"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        customerID = try values.decodeIfPresent(String.self, forKey: .customerID)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        priority = try values.decodeIfPresent(String.self, forKey: .priority)
        deviceID = try values.decodeIfPresent(String.self, forKey: .deviceID)
        timeStamp = try values.decodeIfPresent(String.self, forKey: .timeStamp)
        topic = try values.decodeIfPresent(String.self, forKey: .topic)
        destination = try values.decodeIfPresent(String.self, forKey: .destination)
        read = try values.decodeIfPresent(Int.self, forKey: .read)
        rId = try values.decodeIfPresent(Int.self, forKey: .rId)
    }
}
struct NotificationResponse: Codable {
    let statusCode: String?
    let errorId: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case errorId = "ErrID"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(String.self, forKey: .statusCode)
        errorId = try values.decodeIfPresent(String.self, forKey: .errorId)
    }
    
}
