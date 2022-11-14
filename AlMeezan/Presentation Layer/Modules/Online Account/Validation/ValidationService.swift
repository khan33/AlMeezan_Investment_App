//
//  ValidationService.swift
//  AlMeezan
//
//  Created by Atta khan on 02/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper


protocol ValidationServiceProtocol {
    func validateLoginField(_ text: String?) throws -> String
    func validateCNIC (_ cnic: String?) throws -> String
}


struct ValidationService: ValidationServiceProtocol {
    
    func validateLoginField(_ text: String?) throws -> String {
        guard let txt = text, !txt.isEmpty else {
            throw ValidationError.emptyTxtfieldMsg
        }
        return txt
    }
    
    
    func validateCNIC (_ cnic: String?) throws -> String  {
        guard let cnic = cnic, !cnic.isEmpty else {
            throw ValidationError.emptyCNIC
        }
        guard cnic.count > 12 else {
            throw ValidationError.invalidCNIC
        }
        return cnic
    }
    
    func validateMobileNo(_ mobile: String?) throws -> String {
        guard let mobile = mobile, !mobile.isEmpty else {
            throw ValidationError.emptyMobileNO
        }
        guard mobile.count < 16 && mobile.count > 7 else {
            throw ValidationError.invalidMobileNO
        }
        return mobile
    }
    
    func validateContactNo(_ mobile: String?) throws -> String {
        guard let mobile = mobile, !mobile.isEmpty else {
            throw ValidationError.emptyMobileNO
        }
//        guard mobile.isValidMobileNo else {
//            throw ValidationError.invalidMobileNO
//        }
        return mobile
    }
    
    
    
    func validateEmail(_ email: String?) throws -> String {
        guard let email = email, !email.isEmpty else {
            throw ValidationError.emptyEmail
        }
        guard email.isValidEmail else {
            throw ValidationError.invalidEmail
        }
        return email
    }
    
    
    
    func validateEmailOTPTxtFields(_ code: String?) throws -> String {
        guard let otpCode = code, !otpCode.isEmpty else { throw ValidationError.emptyTxtfieldMsg }
//        KeychainWrapper.standard.set(sMSPin, forKey: "sMSPin")
//        KeychainWrapper.standard.set(emailPin, forKey: "emailPin")
        let emailPin = KeychainWrapper.standard.string(forKey: "emailPin")
        if code != emailPin { throw ValidationError.emailCodeMismtach }
        return otpCode
    }
    
    func validateMobileOTPTxtFields(_ code: String?) throws -> String {
        guard let otpCode = code, !otpCode.isEmpty else { throw ValidationError.emptyTxtfieldMsg }
        let sMSPin = KeychainWrapper.standard.string(forKey: "sMSPin")
        if code != sMSPin { throw ValidationError.mobileCodeMismatch }
        return otpCode
    }
    
    func validateTxtField(_ txtField: String?, _ message: ValidationError) throws -> String {
        guard let txt = txtField, !txt.isEmpty else { throw message }
        return txt
    }
    
    func validateCNICName(_ txtField: String?) throws -> String {
        guard let txt = txtField, !txt.isEmpty else { throw ValidationError.emptyCNICName }
        return txt
    }
    func validateAccountNo(_ txt: String?) throws -> String {
        guard let account = txt, !account.isEmpty else {
            throw ValidationError.emptyAccountNumber
        }
        guard account.isValidIBAN else {
            throw ValidationError.invalidAccountNo
        }
        return account
    }
    
    
    func validateCheckbox(_ isSelected: Bool, _ message: ValidationError) throws -> String {
        if !isSelected {
            throw message
        }
        return ""
        
    }
    func checkTransactionAmount(_ value: Int) throws -> String {
        if value < 5000 || value > 25000 {
            throw ValidationError.transactionAmount
        }
        return String(value)
    }
    
    
    
}
enum ValidationError: LocalizedError {
    case invalidValue
    case emptyCNIC
    case invalidCNIC
    case emptyMobileNO
    case invalidMobileNO
    case invalidEmail
    case emptyEmail
    case emptyTxtfieldMsg
    case emailCodeMismtach
    case mobileCodeMismatch
    case emptyCNICName
    case emptyFName
    case emptydob
    case emptyGender
    case emptyAge
    case emptyIncome
    case emptyOccupation
    case emptyOtherIncome
    case emptyCNICIssue
    case emptyExpireCNIC
    case emptyBankName
    case emptyBranchName
    case emptyAccountTitle
    case emptyAccountNumber
    case emptyAddress1
    case emptyCountry
    case emptyCity
    case invalidAccountNo
    case emptyFundCategory
    case emptyFundPlan
    case emptyAmount
    case emptyUserId
    case emptyPassword
    case transactionAmount
    case checkBoxMsg
    
    var errorDescription: String? {
        switch self {
        case .emailCodeMismtach:
            return "Email OTP mismatch. Please try correct one or resend it again."
        case .mobileCodeMismatch:
            return "Mobile OTP mismatch. Please try correct one or resend it again."
        case .emptyTxtfieldMsg:
            return "Please provide the required information."
        case .emptyMobileNO:
            return "Please enter your mobile number."
        case .invalidMobileNO:
            return "Invalid Mobile Number."
        case .emptyEmail:
            return "Please enter your email."
        case .invalidEmail:
            return "You have entered an invalid e-mail address."
        case .emptyCNIC:
            return "Please enter your CNIC number"
        case .invalidCNIC:
            return "CNIC: must be 13 digits long."
        case .invalidValue:
            return "You have entered an invalid value."
        case .emptyCNICName:
            return "Please enter your CNIC name"
        case .emptyFName:
            return "Please enter your Father / Husband Name."
        case .emptydob:
            return "Please enter your date of birth."
        case .emptyAge:
            return "Please enter your age."
        case .emptyGender:
            return "Please enter your gender."
        case .emptyIncome:
            return "Please enter your Income source."
        case .emptyOtherIncome:
            return "Please enter other income source."
        case .emptyOccupation:
            return "Please enter your occupation."
        case .emptyCNICIssue:
            return "Please enter your CNIC issue date."
        case .emptyExpireCNIC:
            return "Please enter your CNIC Expire date."
        case .emptyBankName:
            return "Please enter your bank name."
        case .emptyBranchName:
            return "Please enter your branch name."
        case .emptyAccountTitle:
            return "Please enter your account title."
        case .emptyAccountNumber:
            return "Please enter your IBAN number."
        case .emptyAddress1:
            return "Please enter your address."
        case .emptyCountry:
            return "Please enter your country."
        case .emptyCity:
            return "Please enter your city."
        case .invalidAccountNo:
            return "You have entered an invalid IBAN number."
        case .emptyFundCategory:
            return "Please enter fund category."
        case .emptyFundPlan:
            return "Please enter Fund / Plan."
        case .emptyAmount:
            return "Please enter amount."
        case .emptyUserId:
            return "Please enter customer Id."
        case .emptyPassword:
            return "Please enter your password."
        case .transactionAmount:
            return "Sorry, Your transaction amount shoud be greater than or equal to PKR 5,000 and less than PKR 25,000"
        case .checkBoxMsg:
            return "Please agree to terms and conditions if you want to proceed."
        }
    }
}
