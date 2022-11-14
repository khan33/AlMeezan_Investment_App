//
//  Validator.swift
//  AlMeezan
//
//  Created by Atta khan on 17/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class Validator: NSObject {
    class func validate(_ items: [ValidItem] ) -> Bool {
        for item in items {
            for role in item.roles {
                let message = valid(type: role, item: item)
                if message != "0" {
                    AlertViewHandler().showAlert(message: message, title: .warning, type: .warning)
                    return false
                }
            }
        }
        return true
    }
    
    
    
    static func valid(type: Role, item: ValidItem) -> String {
        switch type {
        case .equal:
            return ""
        case .required:
            if item.value?.isBlank == true {
                return item.message != nil ? item.message! : "\(item.name ?? "") \("Is Required")"
            }
        case .email:
            if item.value?.isEmail == false {
                return item.message != nil ? item.message! : "\(item.name ?? "") \("Is Invalid")"
            }
        case .phone:
            return ""
        case .confirmation:
            return ""
        case .min:
            return ""
        case .max:
            return ""
        case .password:
            return ""
        case .notOnlyNumber:
            return ""
        }
        return "0"
    }
}

extension String {
    // To check text field or String is blank or not
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    // Validate Email

    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, count)) != nil
        } catch {
            return false
        }
    }

    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
