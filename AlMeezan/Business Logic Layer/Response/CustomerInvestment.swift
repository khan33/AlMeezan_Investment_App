//
//  CustomerInvestment.swift
//  AlMeezan
//
//  Created by Atta khan on 13/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CustomerInvestment)
class CustomerInvestment : NSManagedObject, Codable {
    
	@NSManaged public var portfolioID : String?
    @NSManaged public var customerName : String?
	@NSManaged public var summary : Set<Summary>?
    var isExpandable        :   Bool = true
	enum CodingKeys: String, CodingKey {

		case portfolioID = "PortfolioId"
        case customerName = "CustomerName"
		case summary = "Summary"
        case isExpandable = "isExpandable"
	}

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerInvestment> {
        return NSFetchRequest<CustomerInvestment>(entityName: "CustomerInvestment")
    }
    
    
    
	// MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "CustomerInvestment", in: managedObjectContext) else {
            fatalError("Failed to decode fund summary")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		portfolioID = try values.decodeIfPresent(String.self, forKey: .portfolioID)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
		summary = try values.decode(Set<Summary>.self, forKey: .summary)
        
	}

    // MARK: - Encodable
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(portfolioID, forKey: .portfolioID)
        try container.encode(customerName, forKey: .customerName)
    }
    
}

// MARK: Generated accessors for fundSummary
extension CustomerInvestment {

    @objc(addFundSummaryObject:)
    @NSManaged public func addToFundSummary(_ value: Summary)

    @objc(removeFundSummaryObject:)
    @NSManaged public func removeFromFundSummary(_ value: Summary)

    @objc(addFundSummary:)
    @NSManaged public func addToFundSummary(_ values: NSSet)

    @objc(removeFundSummary:)
    @NSManaged public func removeFromFundSummary(_ values: NSSet)

}
