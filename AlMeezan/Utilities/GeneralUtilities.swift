//
//  GeneralUtilities.swift
//  AlMeezan
//
//  Created by Atta khan on 30/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit

class GeneralUtilities: NSObject {
    static let sharedInstance = GeneralUtilities()
    class func setViewCornerRadius(_ view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    
    class func setViewBorder(_ view: UIView, withWidth width: CGFloat, andColor color: UIColor) {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = 1
    }
    
    func StatusMessage(_ statusCode: String) -> String {
        switch statusCode {
        case "001":
            return "Successful Login"
        case "002":
            return "Unsuccessful login"
        case "101":
            return "Successful Login"
        case "105":
            return "Insufficient Balance"
        case "106":
            return "Parameter Not Found"
        case "102":
            return "Invalid User"
        case "104":
            return "You Are not Register Customer"
        case "201":
            return "Request Has been Sent"
        case "103":
            return "Session Expire"
        case "107":
            return "Complain Submission Failed"
        case "108":
            return "You are already applied for Registration. Email has been Resent."
        case "109":
            return "Enter valid information for subscription."
        case "110":
            return "You are Registered Customer."
        case "111":
            return "You are not able to register from here, Please contact Customer Service for registration."
        case "112":
            return "Thank you for submitting your registration information to Al Meezan. An email has been sent to your email address, to complete your registration and continue with your request, please login to your email account and follow the instructions."
        default:
            return "Successful Login"
        }
    }
}
