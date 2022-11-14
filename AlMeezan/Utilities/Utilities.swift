//
//  Utilities.swift
//  AlMeezan
//
//  Created by Atta khan on 30/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import UIKit
let PROGRESS_INDICATOR_VIEW_TAG:Int = 10


/* Show Progress Indicator */
func showProgressIndicator(view:UIView){
    
    view.isUserInteractionEnabled = false
    
    // Create and add the view to the screen.
    let progressIndicator = ProgressIndicator(text: "Please wait..")
    progressIndicator.tag = PROGRESS_INDICATOR_VIEW_TAG
    view.addSubview(progressIndicator)
    
}

/* Hide progress Indicator */
func hideProgressIndicator(view:UIView){
    
    view.isUserInteractionEnabled = true
    
    if let viewWithTag = view.viewWithTag(PROGRESS_INDICATOR_VIEW_TAG) {
        viewWithTag.removeFromSuperview()
    }
}

func addShadow(btn : UIButton) {
    btn.layer.shadowOpacity = 0.5
    btn.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
    btn.layer.shadowRadius = 5.0
    btn.layer.shadowColor = UIColor(red: 108/255.0, green: 165/255.0, blue: 67/255.0, alpha: 1.0).cgColor
}


func isValidEmailAddress(_ testStr:String) -> Bool {
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}
class MyButton : UIButton {
    var indexPath : IndexPath?
    var isFlag: Bool = false
    
}
func checkProfileByScore(_ score: Int) -> String {
    var profile: String = ""
    
    if 33...38 ~= score {
        profile = "Aggressive"
    } else if 24...32 ~= score {
        profile = "Balanced"
    } else if 15...23 ~= score {
        profile = "Stable"
    } else {
       profile = "Conservative"
    }
    
    
    return profile
}



func showErrorMessage(_ errorId : String) -> String {
    switch errorId {
    case "001":
        return "Successful Login"
    case "002":
        return "Unsuccessful Login"
    case "101":
        return "Data Not Found"
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
    case "113":
        return "Old Password is Incorrect."
    case "114":
        return "You are not Registered Client"
    case "115":
        return "You are not Registered Customer"
    case "116":
        return "Incorrect Information Provided"
    case "117":
        return "Email has been sent to your email address, please login to your email account and follow the instructions."
    case "118":
        return "Dear Customer, Your account is marked as UNVERIFIED, please contact your Sales Advisor or call 0800-42525 for information."
    case "119":
        return "Sorry, Meezan Easy Cash transaction can not be entertained after Cut-Off Time."
    case "120":
        return "Sorry, Your transaction amount should be less than or equal to 100,000 or 80% of balance whichever is lower."
    case "121":
        return "Minimum investment amount for Meezan Rozana Amdani Fund is Rs. 500,000."
    case "122":
        return "Your selected fund is temporarily unavailable."
    case "123":
        return "Minimum investment amount for Meezan Daily Income Plan is Rs. 200,000."
    case "124":
        return "Minimum transaction amount for Meezan Paidar Munafa Plan is Rs.500,000/- & multiple of Rs.500,000/-"
    case "210":
        return "An account is already registered against this CNIC. For more details contact 0800-42525 (HALAL)."
    case "211":
        return "You are exisiting customer of almeezan and not registerd Meezan Funds Online user"
    case "212":
        return "You are exisiting customer of almeezan and registerd Meezan Funds Online user"
    case "213":
        return "Some fields are missing."
    case "214":
        return "Invalid SMS or Email Pin"
    case "215":
        return "Investment Amount should be 5,000 (min) or 25,000 (max)"
    case "216":
        return "You are unable to perform any transaction due to Dormant Account."
    case "217":
        return "This account against this CNIC is already under process. For more details contact 0800-42525 (HALAL)"
    default:
        break
    }
    return ""
}

//119 Sorry, Meezan Easy Cash transaction can not be entertained after Cut-Off Time.
//120 Sorry, Your transaction amount should be less than or equal to 100,000 or 80% of balance whichever is lower.
