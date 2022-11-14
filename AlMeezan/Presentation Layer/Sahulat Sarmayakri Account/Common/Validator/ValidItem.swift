//
//  ValidItem.swift
//  AlMeezan
//
//  Created by Atta khan on 17/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class ValidItem: NSObject {
    var name:       String?
    var value:      String?
    var message:    String?
    var roles:      [Role] = []
    var minNumber:  Int = 0
    var maxNumber:  Int = 300
    var confirmationValue: String?
    
    required init(name: validationText, value: String?, roles: [Role], minNumber: Int = 0, maxNumber: Int = 300, confirmationValue: String? = nil, message: String? = nil) {
        
        self.value      =   value
        self.name       =   name.localize
        self.message    =   message
        self.roles      =   roles
        self.minNumber  =   minNumber
        self.maxNumber  =   maxNumber
        self.confirmationValue = confirmationValue
        
    }
}


enum Role {
    case required
    case min
    case max
    case email
    case phone
    case equal
    case password
    case confirmation
    case notOnlyNumber

}
enum validationText: localizableProtocol {
    var localize: String {
        switch self {
        case .code:
            return "Code"
        case .city:
            return "City"
        case .cnic:
            return "CNIC"
        case .mobile:
            return "Phone"
        case .phone:
            return "Phone"
        case .email:
            return "Email"
        case .gender:
            return "Gender"
        case .country:
            return "Country"
        case .password:
            return "Password"
        case .lastName:
            return "LastName"
        case .location:
            return "Location"
        case .UserName:
            return "UserName"
        case .firstName:
            return "FirstName"
        case .confirmPassword:
            return "Confirm Password"
        case .district:
            return "District"
        case .street:
            return "Street"
        case .simOwner:
            return "simOwner"
            
        }
    }

    case city
    case code
    case phone
    case email
    case cnic
    case gender
    case mobile
    case country
    case UserName
    case location
    case lastName
    case password
    case firstName
    case confirmPassword
    case district
    case street
    case simOwner
}
