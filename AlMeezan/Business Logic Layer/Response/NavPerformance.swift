import Foundation
import CoreData

@objc(NavPerformance)
public class NavPerformance: NSManagedObject, Codable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NavPerformance> {
        return NSFetchRequest<NavPerformance>(entityName: "NavPerformance")
    }

    @NSManaged public var currentFY: Double
    @NSManaged public var cYTD: Double
    @NSManaged public var descriptionStr: String?
    @NSManaged public var fundGroup: String?
    @NSManaged public var fundiD: String?
    @NSManaged public var fundshortname: String?
    @NSManaged public var fund_name: String?
    @NSManaged public var fY: Double
    @NSManaged public var inceptiondate: String?
    @NSManaged public var mTD: Double
    @NSManaged public var nAVDate: String?
    @NSManaged public var nAVPrice: Double
    @NSManaged public var offerPrice: Double
    @NSManaged public var previousFY: Double
    @NSManaged public var redemptionPrice: Double
    @NSManaged public var sign: String?
    @NSManaged public var sinceInception: Double
    var isExpandable: Bool = false
    enum CodingKeys: String, CodingKey {

        case fundGroup = "FundGroup"
        case fundiD = "FundiD"
        case fundshortname = "Fundshortname"
        case redemptionPrice = "RedemptionPrice"
        case offerPrice = "OfferPrice"
        case nAVPrice = "NAVPrice"
        case nAVDate = "NAVDate"
        case mTD = "MTD"
        case cYTD = "CYTD"
        case currentFY = "CurrentFY"
        case previousFY = "PreviousFY"
        case fY = "FY"
        case sinceInception = "SinceInception"
        case fund_name = "fund_name"
        case descriptionStr = "description"
        case inceptiondate = "inceptiondate"
        case sign = "Sign"
        
    }
    
    
    required convenience public init(from decoder: Decoder) throws {
    
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "NavPerformance", in: managedObjectContext) else {
            fatalError("Failed to decode Companies")
        }

        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        fundGroup = try values.decodeIfPresent(String.self, forKey: .fundGroup)
        fundiD = try values.decodeIfPresent(String.self, forKey: .fundiD)
        fundshortname = try values.decodeIfPresent(String.self, forKey: .fundshortname)
        redemptionPrice = try (values.decodeIfPresent(Double.self, forKey: .redemptionPrice) ?? 0.0)
        offerPrice = try (values.decodeIfPresent(Double.self, forKey: .offerPrice) ?? 0.0)
        nAVPrice = try (values.decodeIfPresent(Double.self, forKey: .nAVPrice) ?? 0.0)
        nAVDate = try values.decodeIfPresent(String.self, forKey: .nAVDate)
        mTD = try (values.decodeIfPresent(Double.self, forKey: .mTD) ?? 0.0)
        cYTD = try (values.decodeIfPresent(Double.self, forKey: .cYTD) ?? 0.0)
        currentFY = try (values.decodeIfPresent(Double.self, forKey: .currentFY) ?? 0.0)
        previousFY = try (values.decodeIfPresent(Double.self, forKey: .previousFY) ?? 0.0)
        fY = try (values.decodeIfPresent(Double.self, forKey: .fY) ?? 0.0)
        sinceInception = try (values.decodeIfPresent(Double.self, forKey: .sinceInception) ?? 0.0)
        fund_name = try values.decodeIfPresent(String.self, forKey: .fund_name)
        descriptionStr = try values.decodeIfPresent(String.self, forKey: .descriptionStr)
        inceptiondate = try values.decodeIfPresent(String.self, forKey: .inceptiondate)
        sign = try values.decodeIfPresent(String.self, forKey: .sign)
    }
    // MARK: - Encodable
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fundGroup, forKey: .fundGroup)
        try container.encode(fundiD, forKey: .fundiD)
        try container.encode(fundshortname, forKey: .fundshortname)
        try container.encode(redemptionPrice, forKey: .redemptionPrice)
        try container.encode(offerPrice, forKey: .offerPrice)
        try container.encode(nAVPrice, forKey: .nAVPrice)
        try container.encode(nAVDate, forKey: .nAVDate)
        try container.encode(mTD, forKey: .mTD)
        try container.encode(cYTD, forKey: .cYTD)
        try container.encode(currentFY, forKey: .currentFY)
        try container.encode(previousFY, forKey: .previousFY)
        try container.encode(fY, forKey: .fY)
        try container.encode(sinceInception, forKey: .sinceInception)
        try container.encode(fund_name, forKey: .fund_name)
        try container.encode(fY, forKey: .fY)
        try container.encode(descriptionStr, forKey: .descriptionStr)
        try container.encode(inceptiondate, forKey: .inceptiondate)
        try container.encode(sign, forKey: .sign)
        //try container.encode(navPerformance, forKey: .navPerformance)
    }
}





/*
struct NavPerformance : Codable {
	let fundGroup : String?
	let fundiD : String?
	let fundshortname : String?
	let redemptionPrice : Double?
	let offerPrice : Double?
	let nAVPrice : Double?
	let nAVDate : String?
	let mTD : Double?
	let cYTD : Double?
	let currentFY : Double?
	let previousFY : Double?
	let fY : Double?
	let sinceInception : Double?
	let fund_name : String?
	let description : String?
	let inceptiondate : String?
    var isExpandable: Bool = false
    var sign: String?
    
	enum CodingKeys: String, CodingKey {

		case fundGroup = "FundGroup"
		case fundiD = "FundiD"
		case fundshortname = "Fundshortname"
		case redemptionPrice = "RedemptionPrice"
		case offerPrice = "OfferPrice"
		case nAVPrice = "NAVPrice"
		case nAVDate = "NAVDate"
		case mTD = "MTD"
		case cYTD = "CYTD"
		case currentFY = "CurrentFY"
		case previousFY = "PreviousFY"
		case fY = "FY"
		case sinceInception = "SinceInception"
		case fund_name = "fund_name"
		case description = "description"
		case inceptiondate = "inceptiondate"
        case isExpandable = "isExpandable"
        case sign         = "Sign"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		fundGroup = try values.decodeIfPresent(String.self, forKey: .fundGroup)
		fundiD = try values.decodeIfPresent(String.self, forKey: .fundiD)
		fundshortname = try values.decodeIfPresent(String.self, forKey: .fundshortname)
		redemptionPrice = try values.decodeIfPresent(Double.self, forKey: .redemptionPrice)
		offerPrice = try values.decodeIfPresent(Double.self, forKey: .offerPrice)
		nAVPrice = try values.decodeIfPresent(Double.self, forKey: .nAVPrice)
		nAVDate = try values.decodeIfPresent(String.self, forKey: .nAVDate)
		mTD = try values.decodeIfPresent(Double.self, forKey: .mTD)
		cYTD = try values.decodeIfPresent(Double.self, forKey: .cYTD)
		currentFY = try values.decodeIfPresent(Double.self, forKey: .currentFY)
		previousFY = try values.decodeIfPresent(Double.self, forKey: .previousFY)
		fY = try values.decodeIfPresent(Double.self, forKey: .fY)
		sinceInception = try values.decodeIfPresent(Double.self, forKey: .sinceInception)
		fund_name = try values.decodeIfPresent(String.self, forKey: .fund_name)
		description = try values.decodeIfPresent(String.self, forKey: .description)
		inceptiondate = try values.decodeIfPresent(String.self, forKey: .inceptiondate)
        sign    = try values.decodeIfPresent(String.self, forKey: .sign)
	}

}
*/
