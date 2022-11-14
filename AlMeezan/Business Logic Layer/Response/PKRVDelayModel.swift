//
//  PKRVDelayModel.swift
//  AlMeezan
//
//  Created by Atta khan on 21/01/2020.
//  Copyright © 2019 Atta khan. All rights reserved.
//



import Foundation
import CoreData

@objc(PKRVDelayModel)
class PKRVDelayModel : NSManagedObject ,Codable {
	@NSManaged var tenor : String?
	@NSManaged var days : Double
	@NSManaged var bid : Double
	@NSManaged var datetime : String?
	@NSManaged var entrydatetime : String?
    @NSManaged var ord : String?

	enum CodingKeys: String, CodingKey {

		case tenor = "Tenor"
		case days = "Days"
		case bid = "Bid"
		case datetime = "Datetime"
		case entrydatetime = "entrydatetime"
        case ord = "ord"
	}
    

	required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "PKRVDelayModel", in: managedObjectContext) else {
            fatalError("Failed to decode Companies")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		tenor = try values.decodeIfPresent(String.self, forKey: .tenor)
        days = try (values.decodeIfPresent(Double.self, forKey: .days) ?? 0.0)
        bid = try (values.decodeIfPresent(Double.self, forKey: .bid) ?? 0.0)
		datetime = try values.decodeIfPresent(String.self, forKey: .datetime)
		entrydatetime = try values.decodeIfPresent(String.self, forKey: .entrydatetime)
        ord = try values.decodeIfPresent(String.self, forKey: .ord)
	}
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tenor, forKey: .tenor)
        try container.encode(days, forKey: .days)
        try container.encode(bid, forKey: .bid)
        try container.encode(datetime, forKey: .datetime)
        try container.encode(entrydatetime, forKey: .entrydatetime)
        
    }

}
