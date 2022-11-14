//
//  CodingUserInfoKey+Util.swift
//  AlMeezan
//
//  Created by Atta khan on 25/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
	
