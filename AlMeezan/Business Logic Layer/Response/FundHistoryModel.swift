//
//  FundHistoryModel.swift
//  AlMeezan
//
//  Created by Atta khan on 27/12/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//
//

import Foundation
import CoreData

struct FundHistoryModel : Codable {
    let fUND_NAME : String?
    let history : [History]?

    enum CodingKeys: String, CodingKey {

        case fUND_NAME = "FUND_NAME"
        case history = "History"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fUND_NAME = try values.decodeIfPresent(String.self, forKey: .fUND_NAME)
        history = try values.decodeIfPresent([History].self, forKey: .history)
    }

}




//
//@objc(FundHistoryModel)
//class FundHistoryModel : NSManagedObject, Codable {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<FundHistoryModel> {
//        return NSFetchRequest<FundHistoryModel>(entityName: "FundHistoryModel")
//    }
//
//	 @NSManaged public var fUND_NAME : String?
//	 @NSManaged public var history : Set<History>?
//    //[History]?
//
//	enum CodingKeys: String, CodingKey {
//		case fUND_NAME = "FUND_NAME"
//		case history = "History"
//	}
//
//
//    // MARK: - Decodable
//    required convenience public init(from decoder: Decoder) throws {
//
//        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
//            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
//            let entity = NSEntityDescription.entity(forEntityName: "FundHistoryModel", in: managedObjectContext) else {
//            fatalError("Failed to decode Companies")
//        }
//        self.init(entity: entity, insertInto: managedObjectContext)
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        fUND_NAME = try values.decodeIfPresent(String.self, forKey: .fUND_NAME)
//        history = try values.decode(Set<History>.self, forKey: .history)
//    }
//
//    // MARK: - Encodable
//
//
//       public func encode(to encoder: Encoder) throws {
//           var container = encoder.container(keyedBy: CodingKeys.self)
//           try container.encode(fUND_NAME, forKey: .fUND_NAME)
//           //try container.encode(history, forKey: .history)
//       }
//
//
//
//
//}
//
//// MARK: Generated accessors for navPerformance
//extension FundHistoryModel {
//
//    @objc(addNavPerformanceObject:)
//    @NSManaged public func addToHistory(_ value: History)
//
//    @objc(removeNavPerformanceObject:)
//    @NSManaged public func removeFromHistory(_ value: History)
//
//    @objc(addNavPerformance:)
//    @NSManaged public func addToHistory(_ values: NSSet)
//
//    @objc(removeNavPerformance:)
//    @NSManaged public func removeFromHistory(_ values: NSSet)
//
//}
