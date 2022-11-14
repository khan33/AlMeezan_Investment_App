//
//  AllFundsDescription.swift
//  AlMeezan
//
//  Created by Atta khan on 27/12/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AllFundsDescription)
class AllFundsDescription : NSManagedObject, Codable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllFundsDescription> {
        return NSFetchRequest<AllFundsDescription>(entityName: "AllFundsDescription")
    }
    
	@NSManaged public var fundGroup : String?
    @NSManaged public var sort : Int32
    @NSManaged public var fundDescription : Set<FundDescription>?
    //[FundDescription]?
    
    var isExpandable        :   Bool = true
	enum CodingKeys: String, CodingKey {

		case fundGroup = "FundGroup"
		case fundDescription = "Funds"
        case isExpandable = "isExpandable"
        case sort = "Sort"
	}

// MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "AllFundsDescription", in: managedObjectContext) else {
            fatalError("Failed to decode fund description")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
		fundGroup = try values.decodeIfPresent(String.self, forKey: .fundGroup)
        sort = try (values.decodeIfPresent(Int32.self, forKey: .sort) ?? 0)
		fundDescription = try values.decode(Set<FundDescription>.self, forKey: .fundDescription)
	}
    
// MARK: - Encodable
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fundGroup, forKey: .fundGroup)
        try container.encode(sort, forKey: .sort)
        //try container.encode(history, forKey: .history)
    }

}

// MARK: Generated accessors for navPerformance
extension AllFundsDescription {

    @objc(addFundDescriptionObject:)
    @NSManaged public func addToFundDescription(_ value: FundDescription)

    @objc(removeNavPerformanceObject:)
    @NSManaged public func removeFromFundDescription(_ value: FundDescription)

    @objc(addNavPerformance:)
    @NSManaged public func addToFundDescription(_ values: NSSet)

    @objc(removeNavPerformance:)
    @NSManaged public func removeFromFundDescription(_ values: NSSet)

}
