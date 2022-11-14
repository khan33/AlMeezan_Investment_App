//
//  PSXCompaniesModel.swift
//  AlMeezan
//
//  Created by Atta khan on 04/12/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation  
import CoreData

@objc(PSXCompaniesModel)
class PSXCompaniesModel : NSManagedObject, Codable {
    @NSManaged var symbol : String?	
    @NSManaged var sector : String?
    @NSManaged var marketCode : String?
    @NSManaged var marketStatus : String?
    @NSManaged var last : Float
    @NSManaged var lastTradeVolume : Float
    @NSManaged var bid : Float
    @NSManaged var bidVolume : Float
    @NSManaged var ask : Float
    @NSManaged var askVolume : Float
    @NSManaged var high : Float
    @NSManaged var low : Float
    @NSManaged var netChange : Float
    @NSManaged var open : Float
    @NSManaged var lDCP : Float
    @NSManaged var averagePrice : Float
    @NSManaged var volume : Float
    @NSManaged var totalTrades : Float
    @NSManaged var direction : String?
    @NSManaged var datetime : String?
    @NSManaged var entrydatetime : String?
    @NSManaged var isAdded: Int

    enum CodingKeys: String, CodingKey {

        case symbol = "Symbol"
        case sector = "Sector"
        case marketCode = "MarketCode"
        case marketStatus = "MarketStatus"
        case last = "Last"
        case lastTradeVolume = "LastTradeVolume"
        case bid = "Bid"
        case bidVolume = "BidVolume"
        case ask = "Ask"
        case askVolume = "AskVolume"
        case high = "High"
        case low = "Low"
        case netChange = "NetChange"
        case open = "Open"
        case lDCP = "LDCP"
        case averagePrice = "AveragePrice"
        case volume = "Volume"
        case totalTrades = "TotalTrades"
        case direction = "Direction"
        case datetime = "Datetime"
        case entrydatetime = "entrydatetime"
        case isAdded = "isAdded"
    }
    
    // MARK: - Decodable
    
    

    required convenience init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "PSXCompaniesModel", in: managedObjectContext) else {
            fatalError("Failed to decode Companies")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        sector = try values.decodeIfPresent(String.self, forKey: .sector)
        marketCode = try values.decodeIfPresent(String.self, forKey: .marketCode)
        marketStatus = try values.decodeIfPresent(String.self, forKey: .marketStatus)
        last = try (values.decodeIfPresent(Float.self, forKey: .last) ?? 0.0)
        lastTradeVolume = try (values.decodeIfPresent(Float.self, forKey: .lastTradeVolume) ?? 0.0)
        bid = try (values.decodeIfPresent(Float.self, forKey: .bid) ?? 0.0)
        bidVolume = try (values.decodeIfPresent(Float.self, forKey: .bidVolume) ?? 0.0)
        ask = try (values.decodeIfPresent(Float.self, forKey: .ask) ?? 0.0)
        askVolume = try (values.decodeIfPresent(Float.self, forKey: .askVolume) ?? 0.0)
        high = try (values.decodeIfPresent(Float.self, forKey: .high) ?? 0.0)
        low = try (values.decodeIfPresent(Float.self, forKey: .low) ?? 0.0)
        netChange = try (values.decodeIfPresent(Float.self, forKey: .netChange) ?? 0.0)
        open = try (values.decodeIfPresent(Float.self, forKey: .open) ?? 0.0)
        lDCP = try (values.decodeIfPresent(Float.self, forKey: .lDCP) ?? 0.0)
        averagePrice = try (values.decodeIfPresent(Float.self, forKey: .averagePrice) ?? 0.0)
        volume = try (values.decodeIfPresent(Float.self, forKey: .volume) ?? 0.0)
        totalTrades = try (values.decodeIfPresent(Float.self, forKey: .totalTrades) ?? 0.0)
        direction = try values.decodeIfPresent(String.self, forKey: .direction)
        datetime = try values.decodeIfPresent(String.self, forKey: .datetime)
        entrydatetime = try values.decodeIfPresent(String.self, forKey: .entrydatetime)
    }

    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(sector, forKey: .sector)
        try container.encode(marketCode, forKey: .marketCode)
        try container.encode(marketStatus, forKey: .marketStatus)
        try container.encode(last, forKey: .last)
        try container.encode(lastTradeVolume, forKey: .lastTradeVolume)
        try container.encode(bid, forKey: .bid)
        try container.encode(bidVolume, forKey: .bidVolume)
        try container.encode(ask, forKey: .ask)
        try container.encode(askVolume, forKey: .askVolume)
        try container.encode(high, forKey: .high)
        try container.encode(low, forKey: .low)
        try container.encode(netChange, forKey: .netChange)
        try container.encode(open, forKey: .open)
        try container.encode(lDCP, forKey: .lDCP)
        try container.encode(averagePrice, forKey: .averagePrice)
        try container.encode(volume, forKey: .volume)
        try container.encode(totalTrades, forKey: .totalTrades)
        try container.encode(direction, forKey: .direction)
        try container.encode(datetime, forKey: .datetime)
        try container.encode(entrydatetime, forKey: .entrydatetime)
        
    }
}
