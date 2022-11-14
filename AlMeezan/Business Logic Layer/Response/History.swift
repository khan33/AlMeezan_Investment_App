import Foundation
import CoreData

struct History : Codable {
    let nav_date : String?
    let fUND_NAME : String?
    let nav_value : Double?

    enum CodingKeys: String, CodingKey {

        case nav_date = "nav_date"
        case fUND_NAME = "FUND_NAME"
        case nav_value = "nav_value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        nav_date = try values.decodeIfPresent(String.self, forKey: .nav_date)
        fUND_NAME = try values.decodeIfPresent(String.self, forKey: .fUND_NAME)
        nav_value = try values.decodeIfPresent(Double.self, forKey: .nav_value)
    }

}





//@objc(History)
//public class History : NSManagedObject, Codable {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
//        return NSFetchRequest<History>(entityName: "History")
//    }
//
//
//
//	@NSManaged public var nav_date : String?
//	@NSManaged public var fUND_NAME : String?
//	@NSManaged public var nav_value : Double
//
//	enum CodingKeys: String, CodingKey {
//
//		case nav_date = "nav_date"
//		case fUND_NAME = "fund_name"
//		case nav_value = "nav_value"
//	}
//
//	required convenience public init(from decoder: Decoder) throws {
//
//        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
//            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
//            let entity = NSEntityDescription.entity(forEntityName: "History", in: managedObjectContext) else {
//            fatalError("Failed to decode Companies")
//        }
//
//        self.init(entity: entity, insertInto: managedObjectContext)
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        nav_date = try values.decodeIfPresent(String.self, forKey: .nav_date)
//        fUND_NAME = try values.decodeIfPresent(String.self, forKey: .fUND_NAME)
//        nav_value = try (values.decodeIfPresent(Double.self, forKey: .nav_value) ?? 0.0)
//
//    }
//    // MARK: - Encodable
//
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(nav_date, forKey: .nav_date)
//        try container.encode(fUND_NAME, forKey: .fUND_NAME)
//        try container.encode(nav_value, forKey: .nav_value)
//
//    }
//
//}
