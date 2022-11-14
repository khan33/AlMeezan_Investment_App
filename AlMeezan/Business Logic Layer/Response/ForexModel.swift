import Foundation

@objc(ForexModel)
class ForexModel : NSManagedObject, Codable {
	@NSManaged var symbol : String?
	@NSManaged var open : Float
	@NSManaged var high : Float
	@NSManaged var low : Float
	@NSManaged var close : Float
	@NSManaged var datetime : String?
	@NSManaged var entrydatetime : String?
    @NSManaged var ask : Float
    @NSManaged var bid: Float
    
	enum CodingKeys: String, CodingKey {

		case symbol = "Symbol"
		case open = "Open"
		case high = "High"
		case low = "Low"
		case close = "Close"
		case datetime = "Datetime"
		case entrydatetime = "entrydatetime"
        case ask = "Ask"
        case bid = "Bid"
	}

	required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "ForexModel", in: managedObjectContext) else {
            fatalError("Failed to decode Companies")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        bid = try (values.decodeIfPresent(Float.self, forKey: .bid) ?? 0.0)
        ask = try (values.decodeIfPresent(Float.self, forKey: .ask) ?? 0.0)
        high = try (values.decodeIfPresent(Float.self, forKey: .high) ?? 0.0)
        low = try (values.decodeIfPresent(Float.self, forKey: .low) ?? 0.0)
        open = try (values.decodeIfPresent(Float.self, forKey: .open) ?? 0.0)
        close = try (values.decodeIfPresent(Float.self, forKey: .close) ?? 0.0)
        datetime = try values.decodeIfPresent(String.self, forKey: .datetime)
        entrydatetime = try values.decodeIfPresent(String.self, forKey: .entrydatetime)
	}
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(close, forKey: .close)
        try container.encode(bid, forKey: .bid)
        try container.encode(ask, forKey: .ask)
        try container.encode(high, forKey: .high)
        try container.encode(low, forKey: .low)
        try container.encode(open, forKey: .open)
        try container.encode(datetime, forKey: .datetime)
        try container.encode(entrydatetime, forKey: .entrydatetime)
       
   }
}
