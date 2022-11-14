//
//  SymbolEntity+CoreDataProperties.swift
//  AlMeezan
//
//  Created by Atta khan on 25/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//
//

import Foundation
import CoreData


extension SymbolEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SymbolEntity> {
        return NSFetchRequest<SymbolEntity>(entityName: "SymbolEntity")
    }

    @NSManaged public var symbol: String?

}
