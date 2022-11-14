//
//  FundDescription.swift
//  AlMeezan
//
//  Created by Atta khan on 27/12/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FundDescription)
class FundDescription : NSManagedObject, Codable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FundDescription> {
        return NSFetchRequest<FundDescription>(entityName: "FundDescription")
    }
    
	@NSManaged public var serial : Int16
	@NSManaged public var sFID : Int16
	@NSManaged public var fundName : String?
	@NSManaged public var dateOfInception : String?
	@NSManaged public var objective : String?
	@NSManaged public var whoShouldInvest : String?
	@NSManaged public var keyBenefits : String?
	@NSManaged public var minimumInvestmentAmount : String?
	@NSManaged public var payoutPolicy : String?
	@NSManaged public var lockInPeriod : String?
	@NSManaged public var entryLoad : String?
	@NSManaged public var exitLoad : String?
	@NSManaged public var managementFee : String?
	@NSManaged public var benchmark : String?
	@NSManaged public var investorRiskProfile : String?
	@NSManaged public var fundGroup : String?
	@NSManaged public var fundName1 : String?
    @NSManaged public var mnemonic: String?
    @NSManaged public var youtubeLink: String?
    @NSManaged public var thumbnail: String?
	@NSManaged public var fYTD : Double
	@NSManaged public var fY1 : Double
	@NSManaged public var fY2 : Double
	@NSManaged public var fY3 : Double
	@NSManaged public var fY4 : Double
	@NSManaged public var mtd : Double
	@NSManaged public var sinceInception : Double
    @NSManaged public var cAGR: Double
    @NSManaged public var disclaimer: String?

	enum CodingKeys: String, CodingKey {

		case serial = "Serial"
		case sFID = "SFID"
		case fundName = "FundName"
		case dateOfInception = "DateOfInception"
		case objective = "Objective"
		case whoShouldInvest = "WhoShouldInvest"
		case keyBenefits = "KeyBenefits"
		case minimumInvestmentAmount = "MinimumInvestmentAmount"
		case payoutPolicy = "PayoutPolicy"
		case lockInPeriod = "LockInPeriod"
		case entryLoad = "EntryLoad"
		case exitLoad = "ExitLoad"
		case managementFee = "ManagementFee"
		case benchmark = "Benchmark"
		case investorRiskProfile = "InvestorRiskProfile"
		case fundGroup = "FundGroup"
		case fundName1 = "FundName1"
        case mnemonic = "Mnemonic"
        case youtubeLink = "YoutubeLink"
		case fYTD = "FYTD"
		case fY1 = "FY1"
		case fY2 = "FY2"
		case fY3 = "FY3"
		case fY4 = "FY4"
		case mtd = "Mtd"
		case sinceInception = "SinceInception"
        case cAGR  = "CAGR"
        case thumbnail = "Thumbnail"
        case disclaimer = "Disclaimer"
	}

    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "FundDescription", in: managedObjectContext) else {
            fatalError("Failed to decode Companies")
        }
        self.init(entity: entity, insertInto: managedObjectContext)
		let values = try decoder.container(keyedBy: CodingKeys.self)
        serial = try (values.decodeIfPresent(Int16.self, forKey: .serial) ?? 0)
        sFID = try (values.decodeIfPresent(Int16.self, forKey: .sFID) ?? 0)
		fundName = try values.decodeIfPresent(String.self, forKey: .fundName)
		dateOfInception = try values.decodeIfPresent(String.self, forKey: .dateOfInception)
		objective = try values.decodeIfPresent(String.self, forKey: .objective)
		whoShouldInvest = try values.decodeIfPresent(String.self, forKey: .whoShouldInvest)
		keyBenefits = try values.decodeIfPresent(String.self, forKey: .keyBenefits)
		minimumInvestmentAmount = try values.decodeIfPresent(String.self, forKey: .minimumInvestmentAmount)
		payoutPolicy = try values.decodeIfPresent(String.self, forKey: .payoutPolicy)
		lockInPeriod = try values.decodeIfPresent(String.self, forKey: .lockInPeriod)
		entryLoad = try values.decodeIfPresent(String.self, forKey: .entryLoad)
		exitLoad = try values.decodeIfPresent(String.self, forKey: .exitLoad)
		managementFee = try values.decodeIfPresent(String.self, forKey: .managementFee)
		benchmark = try values.decodeIfPresent(String.self, forKey: .benchmark)
		investorRiskProfile = try values.decodeIfPresent(String.self, forKey: .investorRiskProfile)
		fundGroup = try values.decodeIfPresent(String.self, forKey: .fundGroup)
		fundName1 = try values.decodeIfPresent(String.self, forKey: .fundName1)
        mnemonic = try values.decodeIfPresent(String.self, forKey: .mnemonic)
        youtubeLink = try values.decodeIfPresent(String.self, forKey: .youtubeLink)
        fYTD = try (values.decodeIfPresent(Double.self, forKey: .fYTD) ?? 0.0)
        fY1 = try (values.decodeIfPresent(Double.self, forKey: .fY1) ?? 0.0)
        fY2 = try (values.decodeIfPresent(Double.self, forKey: .fY2) ?? 0.0)
        fY3 = try (values.decodeIfPresent(Double.self, forKey: .fY3) ?? 0.0)
        fY4 = try (values.decodeIfPresent(Double.self, forKey: .fY4) ?? 0.0)
        mtd = try (values.decodeIfPresent(Double.self, forKey: .mtd) ?? 0.0)
        sinceInception = try (values.decodeIfPresent(Double.self, forKey: .sinceInception) ?? 0.0)
        cAGR = try (values.decodeIfPresent(Double.self, forKey: .cAGR) ?? 0)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        disclaimer = try values.decodeIfPresent(String.self, forKey: .disclaimer)
	}
    
  // MARK: - Encodable
    
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(serial, forKey: .serial)
        try container.encode(sFID, forKey: .sFID)
        try container.encode(fundName, forKey: .fundName)
        try container.encode(dateOfInception, forKey: .dateOfInception)
        try container.encode(whoShouldInvest, forKey: .whoShouldInvest)
        try container.encode(objective, forKey: .objective)
        try container.encode(keyBenefits, forKey: .keyBenefits)
        try container.encode(minimumInvestmentAmount, forKey: .minimumInvestmentAmount)
        try container.encode(payoutPolicy, forKey: .payoutPolicy)
        try container.encode(lockInPeriod, forKey: .lockInPeriod)
        try container.encode(entryLoad, forKey: .entryLoad)
        try container.encode(exitLoad, forKey: .exitLoad)
        try container.encode(managementFee, forKey: .managementFee)
        try container.encode(benchmark, forKey: .benchmark)
        try container.encode(investorRiskProfile, forKey: .investorRiskProfile)
        try container.encode(fundGroup, forKey: .fundGroup)
        try container.encode(fundName1, forKey: .fundName1)
        try container.encode(youtubeLink, forKey: .youtubeLink)
        try container.encode(mnemonic, forKey: .mnemonic)
        try container.encode(fYTD, forKey: .fYTD)
        try container.encode(fY1, forKey: .fY1)
        try container.encode(fY2, forKey: .fY2)
        try container.encode(fY3, forKey: .fY3)
        try container.encode(fY4, forKey: .fY4)
        try container.encode(mtd, forKey: .mtd)
        try container.encode(sinceInception, forKey: .sinceInception)
        try container.encode(cAGR, forKey: .cAGR)
        try container.encode(thumbnail, forKey: .thumbnail)
        try container.encode(disclaimer, forKey: .disclaimer)
    }
    
    
}
