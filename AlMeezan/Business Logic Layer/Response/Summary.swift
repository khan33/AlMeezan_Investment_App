//
//  Summary.swift
//  AlMeezan
//
//  Created by Atta khan on 13/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Summary)
class Summary : NSManagedObject, Codable {
    
	@nonobjc public class func fetchRequest() -> NSFetchRequest<Summary> {
        return NSFetchRequest<Summary>(entityName: "Summary")
    }

    @NSManaged public var portfolioID: String?
    @NSManaged public var fundid: String?
    @NSManaged public var fundShortName: String?
    @NSManaged public var agentName: String?
    @NSManaged public var agentId: String?
    @NSManaged public var fundGroupName: String?
    @NSManaged public var fundAgentId: String?
    @NSManaged public var fundAgentName: String?
    @NSManaged public var balunits: Double
    @NSManaged public var nav: Float
    @NSManaged public var relizedGain: Float
    @NSManaged public var unrelizedGain: Float
    @NSManaged public var initailCost: Float
    @NSManaged public var marketValue: Double
    @NSManaged public var nav_date: String?
    @NSManaged public var sinceInceptionGain: Float
    @NSManaged public var fYGain: Float
    @NSManaged public var purchases: Float
    @NSManaged public var redemption: Float
    @NSManaged public var monthyIncome: Float
    

	enum CodingKeys: String, CodingKey {

		case portfolioID = "PortfolioID"
		case fundid = "Fundid"
		case fundShortName = "FundShortName"
		case agentName = "AgentName"
		case agentId = "AgentId"
		case fundGroupName = "FundGroupName"
		case fundAgentId = "FundAgentId"
		case fundAgentName = "FundAgentName"
		case balunits = "balunits"
		case nav = "Nav"
		case relizedGain = "RelizedGain"
		case unrelizedGain = "UnrelizedGain"
		case initailCost = "InitailCost"
		case marketValue = "MarketValue"
		case nav_date = "Nav_date"
		case sinceInceptionGain = "SinceInceptionGain"
		case fYGain = "FYGain"
		case purchases = "Purchases"
		case redemption = "Redemption"
        case monthyIncome = "MonthyIncome"
	}
    
    

	// MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Summary", in: managedObjectContext) else {
            fatalError("Failed to decode summary")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		portfolioID = try values.decodeIfPresent(String.self, forKey: .portfolioID)
		fundid = try values.decodeIfPresent(String.self, forKey: .fundid)
		fundShortName = try values.decodeIfPresent(String.self, forKey: .fundShortName)
		agentName = try values.decodeIfPresent(String.self, forKey: .agentName)
		agentId = try values.decodeIfPresent(String.self, forKey: .agentId)
		fundGroupName = try values.decodeIfPresent(String.self, forKey: .fundGroupName)
		fundAgentId = try values.decodeIfPresent(String.self, forKey: .fundAgentId)
		fundAgentName = try values.decodeIfPresent(String.self, forKey: .fundAgentName)
		nav_date = try values.decodeIfPresent(String.self, forKey: .nav_date)
        
        if let bal_units = try? values.decode(Int.self, forKey: .balunits) {
            balunits = Double(bal_units)
        } else {
            balunits = try (values.decodeIfPresent(Double.self, forKey: .balunits) ?? 0.0)
        }
        
        if let nav_value = try? values.decode(Int.self, forKey: .nav) {
            nav = Float(nav_value)
        } else {
            nav = try (values.decodeIfPresent(Float.self, forKey: .nav) ?? 0.0)
        }
        
        if let relizedGain_value = try? values.decode(Int.self, forKey: .relizedGain) {
            relizedGain = Float(relizedGain_value)
        } else {
            relizedGain = try (values.decodeIfPresent(Float.self, forKey: .relizedGain) ?? 0.0)
        }
        
        if let unrelizedGain_value = try? values.decode(Int.self, forKey: .unrelizedGain) {
            unrelizedGain = Float(unrelizedGain_value)
        } else {
            unrelizedGain = try (values.decodeIfPresent(Float.self, forKey: .unrelizedGain) ?? 0.0)
        }
        
        if let initailCost_value = try? values.decode(Int.self, forKey: .initailCost) {
            initailCost = Float(initailCost_value)
        } else {
            initailCost = try (values.decodeIfPresent(Float.self, forKey: .initailCost) ?? 0.0)
        }
        if let marketValue_value = try? values.decode(Int.self, forKey: .marketValue) {
            marketValue = Double(marketValue_value)
        } else {
            marketValue = try (values.decodeIfPresent(Double.self, forKey: .marketValue) ?? 0.0)
        }
        
        if let sinceInceptionGain_value = try? values.decode(Int.self, forKey: .sinceInceptionGain) {
            sinceInceptionGain = Float(sinceInceptionGain_value)
        } else {
            sinceInceptionGain = try (values.decodeIfPresent(Float.self, forKey: .sinceInceptionGain) ?? 0.0)
        }
        if let fYGain_value = try? values.decode(Int.self, forKey: .fYGain) {
            fYGain = Float(fYGain_value)
        } else {
            fYGain = try (values.decodeIfPresent(Float.self, forKey: .fYGain) ?? 0.0)
        }
        if let purchases_value = try? values.decode(Int.self, forKey: .purchases) {
            purchases = Float(purchases_value)
        } else {
            purchases = try (values.decodeIfPresent(Float.self, forKey: .purchases) ?? 0.0)
        }
        if let redemption_value = try? values.decode(Int.self, forKey: .redemption) {
            redemption = Float(redemption_value)
        } else {
            redemption = try (values.decodeIfPresent(Float.self, forKey: .redemption) ?? 0.0)
        }
        
        
        if let monthyIncome_value = try? values.decode(Int.self, forKey: .monthyIncome) {
            monthyIncome = Float(monthyIncome_value)
        } else {
            monthyIncome = try (values.decodeIfPresent(Float.self, forKey: .monthyIncome) ?? 0.0)
        }
        
	}
    
    // MARK: - Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(portfolioID, forKey: .portfolioID)
        try container.encode(fundid, forKey: .fundid)
        try container.encode(fundShortName, forKey: .fundShortName)
        try container.encode(agentName, forKey: .agentName)
        try container.encode(agentId, forKey: .agentId)
        try container.encode(fundGroupName, forKey: .fundGroupName)
        try container.encode(fundAgentId, forKey: .fundAgentId)
        try container.encode(fundAgentName, forKey: .fundAgentName)
        try container.encode(balunits, forKey: .balunits)
        try container.encode(nav, forKey: .nav)
        try container.encode(relizedGain, forKey: .relizedGain)
        try container.encode(unrelizedGain, forKey: .unrelizedGain)
        try container.encode(initailCost, forKey: .initailCost)
        try container.encode(marketValue, forKey: .marketValue)
        try container.encode(nav_date, forKey: .nav_date)
        try container.encode(sinceInceptionGain, forKey: .sinceInceptionGain)
        try container.encode(fYGain, forKey: .fYGain)
        try container.encode(purchases, forKey: .purchases)
        try container.encode(redemption, forKey: .redemption)
        try container.encode(monthyIncome, forKey: .monthyIncome)
        
        
        //try container.encode(history, forKey: .history)
    }

}
