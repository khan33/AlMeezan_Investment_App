//
//  AppStrings.swift
//  AlMeezan
//
//  Created by Atta khan on 16/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

enum AppString {
    
    // MARK: - App Global
    static let appName = "Al Meezan"
    enum Heading {

    // MARK: - BASIC INFORMAITON
        static let SSA = "Sahulat Sarmayakari Account"
        static let basicInfo = "Basic Information"
        static let savebtn  = "SAVE AND CONTINUE"
        static let cnic = "CNIC/NICOP"
        static let mobileNumber = "Mobile Number"
        static let email = "Email"
        static let ownership = "Ownership of your Mobile No."

    // MARK: - OTP SCREEN
        static let otp =  "OTP"
        static let enterOTP = "Enter OTP received"
        static let notReceivedCode = "Code not received?"
        static let resendOTP = "Resend code"
        static let veriftyOTPBtn = "VERIFY OTP"

    // MARK: - SELECT FUND
        static let selectFund = "Select Category"

        // MARK: - PERSONAL INFORMATION
        static let personalInfo = "Personal Information"
        static let name = "Name (as per CNIC)"
        static let fName = "Father/Husband’s Name"
        static let mName = "Mother’s Maiden Name"
        static let cnicNicop = "CNIC/NICOP"
        static let cnicIssue = "CNIC Issue Date"
        static let dob = "Date of Birth"
        static let cnicExpiry = "CNIC Expiry Date"
        static let validForLife = "CNIC Valid for Lifetime"
        static let materialStatus = "Marital Status"
        static let nationality = "Nationality"
        static let dualNationality = "Dual Nationality"
        static let residentaialStatus = "Residential Status"
        static let religion = "Religion"
        static let zakatExpemption = "Zakat Exemption"
        static let zakatYes = "(NDZ-Non-Deduction Affidavit of Zakat is required)"
        static let healthDec = "Health Declaration"
        static let accountHolder = "Joint Account Holder (Optional)"
        static let cnicPassport = "CNIC/NICOP/Passport"
        static let cnicMobileOwner = "CNIC/NICOP of Mobile Number Owner"


    // MARK: - Contact Details
        static let contactDetails = "Contact Details"
        static let phoneNumber = "Phone Number"
        static let officeNumber = "Office Number"
        static let emailAddress =  "Email Address"
        static let currentAddress = "Current Address"
        static let permanentAddress = "Permanent Address"
        static let currentCoutryAddress = "Current Address Country"
        static let permanentCountryAddress = "Permanent Address Country"
        static let sameAsCurrent = "Same as current"

    // MARK: - Bank Details
        static let bankDetail = "BANK DETAILS (Principal Account Holder only)"
        static let bankName = "Bank Name"
        static let branchName = "Branch Name"
        static let branchCity = "Branch City"
        static let iban = "Account Number(IBAN Number Only)"
        static let divideMandate = "Dividend Mandate"
        static let cashDivide = "Cash Dividend"
        static let stockDivide = "Stock Dividends"
        static let nextOfKIN = "Next of KIN (Optional)"
        static let officeNo = "Office Number."
        static let contactNumber = "Contact Number "
        static let address = "Address"
        static let relationshipKin = "Relationship With Customer"
        
        static let numbeerOfTransaction = "Number Of Transactions/Quantity"
        static let expectedAmount = "Expected Turnover in Account in Rupees"
        static let employeePhoneNo = "Employer's Phone Number"
        static let transactionAmount = "Transaction Amount(Must be > 5000)"
        static let physicianName = "Personal Physician (Name and Address)"
        static let salePersonId = "Sales Person ID"
    }
    enum PlaceHoderText {
        // MARK: - BASIC INFORMAITON
        static let enterCNIC = "Enter Your CNIC"
        static let enterMobileNumber = "Enter Your Mobile Number"
        static let enterEmail = "Enter Your Email Address"
        static let selectOwnership = "Select Ownership Of Mobile Number"
        
        // MARK: - PERSONAL INFORMAITON
        static let enterName = "Enter Your Name"
        static let enterFname = "Enter Your Father/Husband’s Name"
        static let enterMname = "Enter Your Mother’s Maiden Name"
        static let enterCNICNICOP = "Enter Your CNIC/NICOP"
        static let enterCNICIssueDate = "Enter Your CNIC Issue Date"
        static let enterCNICExpiryDate = "Enter Your CNIC Expiry Date"
        static let enterNationality = "Enter Your Nationality"
        static let enterMaterialStatus = "Enter Your Marital Status"
        static let enterDualNationality = "Enter Your Dual Nationality"
        static let enterResidentStatus = "Enter Your Residential Status"
        static let enterRelegion = "Enter Your Religion"
        static let enterDob = "Enter Your Date of Birth"
        
        // MARK: - CONTACT DETAILS
    
        static let enterPhoneNumber = "Enter Your Phone Number"
        static let enterOfficeNumber = "Enter Your Office Number"
        static let enterEmailAddress = "Enter Your Email Address"
        static let enterCurrentAddress = "Enter Your Current Address"
        static let enterPermanentAddress = "Enter Your Permanent Address"
        static let enterCountryAddress = "Enter Your Country Address"
        static let enterCountryPermanentAddress = "Enter Your Country Permanent Address"
        
        // MARK: - Bank Details
        
        static let enterBankName = "Enter your Bank Name"
        static let enterBranchName = "Enter your Branch Name"
        static let enterBranchCity = "Enter Your Branch City"
        static let enterIBAN = "Enter Your IBAN"
        static let enterCashDividend = "Enter Cash Dividend"
        static let enterStockDividend = "Enter Stock Dividend"
        static let enterContactNumber = "Enter Your Contact Number"
        static let enterAddress = "Enter Your Address"
        static let enterRelationship = "Enter Your Relationship"
        
        
        
        
    }
    
}
