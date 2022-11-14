//
//  FundEntity+CoreDataProperties.swift
//  AlMeezan
//
//  Created by Atta khan on 21/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//
//

import Foundation
import CoreData


extension FundEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FundEntity> {
        return NSFetchRequest<FundEntity>(entityName: "FundEntity")
    }

    @NSManaged public var entryLoad: String?
    @NSManaged public var exitLoad: String?
    @NSManaged public var fund_group: String?
    @NSManaged public var fund_name: String?
    @NSManaged public var fund_size: String?
    @NSManaged public var fundCategory: String?
    @NSManaged public var management_fee: String?
    @NSManaged public var risk_level: String?

}
