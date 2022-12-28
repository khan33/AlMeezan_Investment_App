//
//  Enum.swift
//  AlMeezan
//
//  Created by Atta khan on 14/01/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

enum Environment: String {
    case development = "Development"
    case production = "Production"
}

enum TransactionType: String {
    case investment = "Investment"
    case conversion = "Conversion"
    case redemption = "Redemption"
    case mtpfRedemption = "MTPFREDEMPTION"
    case mtpfChangeOfPlan = "MTPFCHANGEOFPLAN"
}

enum MarketState: String {
    case Advancers = "Advancers"
    case Decliners = "Decliners"
    case ActiveSectors = "Active Sectors"
    case ActiveCompanies = "Active Companies"
}

enum MoneyMarketState: String {
    case kibor = "Kibor"
    case PKRV = "PKRV"
    case PIB = "PIB"
    case SUKUK  = "Sukuk"
}


enum CommoditiesState: String {
    case gold = "Gold"
    case sliver = "Sliver"
    case Oil = "Oil"
}

enum BiometricType: String {
    case none = "none"
    case touchID = "touchId"
    case faceID = "faceId"
}

enum LoginType: String {
    case manual     =   "Manual"
    case touchId    =   "Finger"
    case faceId     =   "Face"
}


enum CellState {
    case Expanded
    case Collapsed
}


enum Destination: String {
    case nav = "NAV"
    case blog = "BLOG"
    case youtube = "YOUTUBE"
    case news = "NEWS"
    case fmr = "FMR"
    case mkt = "MKT"
    case lead = "LEAD"
    case reg = "REG"
    case investment = "INV"
    case conversion = "CON"
    case redemption = "RED"
    case otpNotify  = "FCM_KEY_ONLINE_ACCOUNT"
    case biometricNotify = "FCM_KEY_BIOMETRIC"
}
enum HomeScreenEnums: Int {
    
    case MARKET_WATCH = 1
    case INVESTMENT_PRODUCTS
    case WHERE_TO_INVEST
    case FUND_PERFORMANCE_REPORT
    case INVESTOR_EDUCATION
    case BECOME_AN_INVESTOR
    case INVESTOR_LOGIN
    var index: Int {
        return rawValue
    }
    var value: String {
        switch self {
        case .MARKET_WATCH:
            return "market_watch"
        case .INVESTMENT_PRODUCTS:
            return "investment_Products"
        case .WHERE_TO_INVEST:
            return "where_to_invest"
        case .FUND_PERFORMANCE_REPORT:
            return "fund_performance_report"
        case .INVESTOR_EDUCATION:
            return "investor_education"
        case .BECOME_AN_INVESTOR:
            return "become_an_investor"
        case .INVESTOR_LOGIN:
            return "Investor_login"
        }
    }
    var screenName: String {
        switch self {
        case .MARKET_WATCH:
            return "Market Watch"
        case .INVESTMENT_PRODUCTS:
            return "Investment Products"
        case .WHERE_TO_INVEST:
            return "Where to Invest"
        case .FUND_PERFORMANCE_REPORT:
            return "Fund Performance Report"
        case .INVESTOR_EDUCATION:
            return "Investor Education"
        case .BECOME_AN_INVESTOR:
            return "Become an Investor"
        case .INVESTOR_LOGIN:
            return "Investor Login"
        }
    }
}

enum OnlineAccountEnums: Int {
    case STEP_ONE = 1
    case STEP_TWO
    case STEP_THREE
    case STEP_FOUR
    case STEP_FIVE
    case STEP_SIX
    case STEP_SEVEN
    case STEP_EIGHT
    var index: Int {
            return rawValue
        }
    var value: String {
            switch self {
            case .STEP_ONE:
                return "step_1_online_account"
            case .STEP_TWO:
                return "step_2_otp_verification"
            case .STEP_THREE:
                return "step_3_personal_details"
            case .STEP_FOUR:
                return "step_4_bank_contact_details"
            case .STEP_FIVE:
                return "step_5_confirmation_screen"
            case .STEP_SIX:
                return "step_6_investment_screen"
            case .STEP_SEVEN:
                return "step_7_success_screen"
            case .STEP_EIGHT:
                return "step_8_thank_you_screen"
            }
        }
    var screenName: String {
        switch self {
        case .STEP_ONE:
            return "Online Account Opening"
        case .STEP_TWO:
            return "Online Account Opening OTP"
        case .STEP_THREE:
            return "Personal Details"
        case .STEP_FOUR:
            return "Bank & Contact Details"
        case .STEP_FIVE:
            return "Confirm Details"
        case .STEP_SIX:
            return "Fund Details"
        case .STEP_SEVEN:
            return "Finish"
        case .STEP_EIGHT:
            return "Thank You"
        }
    }
}
