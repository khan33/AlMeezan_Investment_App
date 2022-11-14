//
//  NavModel.swift
//  AlMeezan
//
//  Created by Atta khan on 09/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import CoreData

@objc(NavModel)
public class NavModel: NSManagedObject, Codable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NavModel> {
        return NSFetchRequest<NavModel>(entityName: "NavModel")
    }

    @NSManaged public var fundGroup: String?
    @NSManaged public var fundsort: Int32
    @NSManaged public var navPerformance: Set<NavPerformance>?
    enum CodingKeys: String, CodingKey {

        case fundGroup = "FundGroup"
        case fundsort = "Sort"
        case navPerformance = "NavPerformance"
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
    
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "NavModel", in: managedObjectContext) else {
            fatalError("Failed to decode Companies")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fundGroup = try values.decodeIfPresent(String.self, forKey: .fundGroup)
        fundsort = Int32(try (values.decodeIfPresent(Int.self, forKey: .fundsort) ?? 0))
        navPerformance = try values.decode(Set<NavPerformance>.self, forKey: .navPerformance)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fundGroup, forKey: .fundGroup)
        try container.encode(fundsort, forKey: .fundsort)
        
    }
    

}

// MARK: Generated accessors for navPerformance
extension NavModel {

    @objc(addNavPerformanceObject:)
    @NSManaged public func addToNavPerformance(_ value: NavPerformance)

    @objc(removeNavPerformanceObject:)
    @NSManaged public func removeFromNavPerformance(_ value: NavPerformance)

    @objc(addNavPerformance:)
    @NSManaged public func addToNavPerformance(_ values: NSSet)

    @objc(removeNavPerformance:)
    @NSManaged public func removeFromNavPerformance(_ values: NSSet)

}
