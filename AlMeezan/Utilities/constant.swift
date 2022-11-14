//
//  constant.swift
//  AlMeezan
//
//  Created by Atta khan on 05/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEGHT = UIScreen.main.bounds.size.height
let persistence = PersistenceServices.shared
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let marketWatchStoryboard = UIStoryboard(name: "Marketwatch", bundle: nil)
var counter = 120
var totalUnreadNotify = 0
var pickerTitleFontSize: CGFloat = 11

let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
let key = "UsmanAlmeezan123"
let iv = "Hello World12345"

let str = "Cz8rCh9OZqZEVJFCIDQeS885W6Cx2sIs467SLd5H2+j8co7k9ZAC6b85+5QLuEJxdMeR10zezpQxYWXUj5AXISs+wkmoW6CdCbjci3fAfxwO5JnzwADa+Sb1ZGiya1mEjHjh+ue0+xP22954oGZFFQ=="
let tmpString = "[{\"statusCode\":\"001\",\"Customerid\":\"176399\",\"tokenID\":\"OLdUNtNzErC6dOW2lILB\",\"DataStatus\":\"false\"}]"
#if DEVELOPMENT
//let BASE_URL = "https://members.almeezangroup.com/webapitest/api/"
#else
//let BASE_URL = "https://members.almeezangroup.com/webapitest/api/"
//let BASE_URL = "https://members.almeezangroup.com/MobileApi/api/"
#endif

//let BASE_URL = "https://members.almeezangroup.com/MobileApiV2/api/"
let BASE_URL = "https://members.almeezangroup.com/webapitest/api/"


let CUSTOMER_LOGIN      =   BASE_URL + "customerlogin"
let BIOMETRIC_LOGIN     =   BASE_URL + "Biometric"
let NAV_PERFORMANCE     =   BASE_URL + "NavPerformance"
let NAV_HISTORY         =   BASE_URL + "NavHistory"
let BRANCHLOCATOR       =   BASE_URL + "BranchLocator"
let ALL_FUND_DESCRIPTION = BASE_URL + "AllFundsDescription"
let FOF_DESCRIPTION     =   BASE_URL + "FOFDescription"
let CONTACT_US          =   BASE_URL + "ContactUs"
let FUND_SUGGESTION     =   BASE_URL + "FundSuggestion"
let FUND_FILTER         =   BASE_URL + "FundFilters"
let CRM_LEAD            =   BASE_URL + "CRMLead"
let TAX_CALCULATOR      =   BASE_URL + "Calculator"
let CUSTOMER_INVESTMENT =   BASE_URL + "customerInvestment"
let INVESTMENT_FUND     =   BASE_URL + "InvestmentFunds"
let CONVERSION_FUND     =   BASE_URL + "ConversionFund"
let CUSTOMER_DETAILS    =   BASE_URL + "customerDetail"
let TRANSACTION_DETAILS =   BASE_URL + "TransactionDetail"
let MOBILE_TRANSACTION  =   BASE_URL + "MobileTransactions"
let RETIREMENT_CALCULATOR = BASE_URL + "RetirementCalculator"
let FOREXSPOT           =   BASE_URL + "ForexSpot"
let PSX_COMPANIES_TOP   =   BASE_URL + "PSXCompaniesTop"
let PSX_SECTOR_TOP      =   BASE_URL + "PSXSectorTop"
let PSX_COMPANIES       =   BASE_URL + "PSXCompanies"
let KIBOR_DELAY         =   BASE_URL + "KIBORDelay"
let PKR_DELAY           =   BASE_URL + "PKRVDelay"
let COMMODITIES         =   BASE_URL + "Commodities"
let PSX_INDIXES         =   BASE_URL + "PSXIndixes"
let PSX_COMPANY_INDICES   =   BASE_URL + "PSXCompanyIndices"
let MY_STOCK            =   BASE_URL + "MyStock"
let PIB_RETURN          =   BASE_URL + "PIBReturn"
let REQUEST_LOGIN       =   BASE_URL + "RequestForLogin"
let FORGOT_PASSWORD     =   BASE_URL + "ForgotPassword"
let ACTIVE_COMPANIES    =   BASE_URL + "ActiveCompanies"
let MOBILE_INVESTMENT   =   BASE_URL + "MobileInvestment"
let TRANSACTION_SUBMISSION = BASE_URL + "TransactionSubmission"
let COMPLAIN_LIST       =   BASE_URL + "ComplainList"
let COMPLAINT           =   BASE_URL + "Complaint"
let COMPLAIN_VIEW       =   BASE_URL + "ComplainView"
let NOTIFICATION_LIST   =   BASE_URL + "Notification"
let MECTEXT             =   BASE_URL + "MECText"
let NOTIFICATION_READER  =  BASE_URL + "Notificationreader"
let GUEST_KEY           =   BASE_URL + "GuestKey"
let BANK_LIST           =   BASE_URL + "InvestmentBanks"
let HIGHT_TEXT          =   BASE_URL + "HighRiskText"
let SUKUK_LIST          =   BASE_URL + "GOPSukuk"
let PKRV_PIB_LIST       =   BASE_URL + "PKRV_PIB_Returns"

let OTP_SEND            =   BASE_URL + "OTPSend"
let VERIFY_OTP          =   BASE_URL + "OTPVerify"
let OCCUPATION          =   BASE_URL + "Occupation"
let COUNTRY_CITY        =   BASE_URL + "CountryCity"
let ACCOUNT_OPENING     =   BASE_URL + "AccountOpening"
let ACCOUNT_OPENING_FUNDS =   BASE_URL + "AccountOpeningFunds"
let ACCOUNT_OPENING_INVESTMENT =   BASE_URL + "AccountOpeningInvestment"
let ROSHAN_ACCOUNT      =   BASE_URL + "OTPSendRoshan"



//Complaint
let BLOG_URL            =   "https://members.almeezangroup.com/Blogs.htm"
let YOUTUBE_CHANNEL     =   "https://www.youtube.com/playlist?list=PLg09bNSN_y19Ux1grcU0a-crH8Q2zdaOk"//"https://www.youtube.com/channel/UCvZc_VKkWlJmNArnoMU3lgQ/featured"
let FAQS                =   "https://members.almeezangroup.com/faq.htm"
let NEWS_UPDATE         =   "https://members.almeezangroup.com/NewsUpdates.aspx"
let RSS_FEED_NEWS       =   "https://feeds.feedburner.com/MettisGlobalNews"
let FUND_REPORTS        =   "https://members.almeezangroup.com/MembersFMR.aspx"
let TERMS_CONDITIONS    =   "https://members.almeezangroup.com/termandcond.htm"
let BIO_LOGIN_TERMS_CONDITIONS = "https://members.almeezangroup.com/TERMANDCONDBiometric.htm"
let EXISTING_ACCOUNT_RDA =   "https://digitalservices.meezanbank.com/amimAccount/"
let NEW_ACCOUNT_RDS     =   "https://digitalservices.meezanbank.com/OAOF/?source=qywajkd9852e68"
let KYC_DETAILS_PRINCIPAL = "https://www.almeezangroup.com/download/miscellaneous/KYC_Requirement_for_Individuals.pdf"
let ALLOCATION_SCHEME = "https://members.almeezangroup.com/RetirementPlans.html"

var minimumAmount:  Int = 1000
var minimumUnit:    Double = 50.0000
var errorResponse: [ErrorResponse]?








var citiesArray = [
    "Abbottabad",
    "Adda Chhabell",
    "Abdul Hakim",
    "Ahmed Pur East",
    "Ahmad Pur Sial",
    "Ajnian Wala",
    "Akbarpur",
    "Akhtarabad",
    "Alipur",
    "Alipur Chatta",
    "Alizai",
    "Amin Pur",
    "Arifwala",
    "Attock",
    "Badah",
    "Badomalhi",
    "Badin",
    "Bagh",
    "Baghwal",
    "Bahawalnagar",
    "Bahawalpur",
    "Bahrain",
    "Bakhshu",
    "Bala Kot",
    "Balkasar",
    "Banda Dawood Shah",
    "Bandhi",
    "Bannu",
    "Bara",
    "Bari Kot",
    "Barian",
    "Basal",
    "Batgram",
    "Batkhela",
    "Basirpur",
    "Bela",
    "Bewal",
    "Bhagowal",
    "Bhagtanwala",
    "Bhai Pheru",
    "Bhakkar",
    "Bhalot",
    "Bhalwal",
    "Bhan Saeedabad",
    "Bhaun",
    "Bhawana",
    "Bhera",
    "Bheriya Road",
    "Bhirya City",
    "Bhit Shah",
    "Billi Tong",
    "Birote",
    "Bonga Saleh",
    "Bongh Sharif",
    "Bucheki",
    "Buffa",
    "Buleda",
    "Bungla Dero",
    "Burewala",
    "Chagharmatti",
    "Chak Jhumra",
    "Chak No.273Jb",
    "Chak No.318",
    "Chak No.1",
    "Chak No.15 Sb",
    "Chak No.24/Gb",
    "Chak No.33",
    "Chak No.47/2-L",
    "Chakdara",
    "Chakwal",
    "Chaman",
    "Changa Manga",
    "Charsadda",
    "Chawinda",
    "Chichawatni",
    "Chichoki Mallian",
    "Chiniot",
    "Chistian",
    "Chitral",
    "Choa Saiden Shah",
    "Choa Lahore",
    "Choti",
    "Chowk Azam",
    "Chowk Munda",
    "Chowk Pandori",
    "Chunian",
    "Company Bagh",
    "D.G.Khan",
    "D.I.Khan",
    "Dadu",
    "Daggar",
    "Dharanwala",
    "Dal Bandin",
    "Damba",
    "Darra Adam Khail",
    "Daraban",
    "Darsamand",
    "Darya Khan",
    "Daska",
    "Daulat Nagar",
    "Daulatpur Saffan",
    "Daur",
    "Depalpur",
    "Dera Allahyar(Nasirabad)",
    "Dera Bugti",
    "Dera Murad Jamali",
    "Dewal Sharif",
    "Dhabeji",
    "Dhadar",
    "Dharki",
    "Dhudial",
    "Digikot",
    "Digree",
    "Dina",
    "Dinga",
    "Diplo",
    "Dir",
    "Dobian",
    "Dokri",
    "Domail",
    "Drosh",
    "Dukki",
    "Dunyapur",
    "Ellahabad",
    "Eminabad",
    "Faisalabad",
    "Faqir Wali",
    "Farooqabad",
    "Fateh Jang",
    "Fateh Pur",
    "Fazil Pur",
    "Feroz Wattan",
    "Ferozwala",
    "Fort Abbas",
    "Fort Munro",
    "Gadap",
    "Gadani",
    "Gadoon Amazai",
    "Gaggo Mandi",
    "Gakkar",
    "Galanai",
    "Gambat",
    "Garhi Kapura",
    "Garhi Mori",
    "Garhi Nori",
    "Garhi Yasin",
    "Gawadar",
    "Ghazni Khel",
    "Ghotki",
    "Ghour Gashti",
    "Gilgit",
    "Gojra",
    "Gomal University(DIK)",
    "Gujar Khan",
    "Gujranwala",
    "Gujrat",
    "Gularchi",
    "Gulshan-e-Hadeed",
    "Hafizabad",
    "Haiderabad Thall",
    "Hala",
    "Hangu",
    "Haram Zai",
    "Harrapa City",
    "Haripur",
    "Harnai",
    "Haroon Abad",
    "Hasan Adbal",
    "Hasil Pur",
    "Hattar-HRP",
    "Hattian",
    "Haveli Lakhan",
    "Havelian",
    "Hazro",
    "Hawana",
    "Hazrat Sultan Bahu",
    "Hub",
    "Hujra Shah Muqeem",
    "Hunak",
    "Hyderabad",
    "Isakhel",
    "Islamabad",
    "Jaccobabad",
    "Jahangira",
    "Jahanian",
    "Jalalpur Jattan",
    "Jalapur Pirwala",
    "Jam Nawaz Ali",
    "Jam Cheema",
    "Jampur",
    "Jamrud",
    "Jand",
    "Jandiala Dhabawala",
    "Jranwala",
    "Jatoi",
    "Jhang",
    "Jharban",
    "Jhawarian",
    "Jhelum",
    "Jhuddo",
    "Jauharabad",
    "Johi",
    "Kabal",
    "Kabirwala",
    "Kacha Khu",
    "Kahuta",
    "Kakul(AT)",
    "Kala Bagh",
    "Kalar Sayedan",
    "Kalaske",
    "Kalat",
    "Kaloor Kot",
    "Kamalia",
    "Kambar Ali Khan",
    "Kamoke",
    "Kamra",
    "Kandh Kot",
    "Kandiaro",
    "Kanian Bangla",
    "Karachi",
    "Karak",
    "Karampur",
    "Karor Lalieson",
    "Karor Pacca",
    "Karrianwala",
    "Kashmore",
    "Kasur",
    "Khairpur",
    "Khairpur Nathan Shan",
    "Khairpur Tamewali",
    "Khal",
    "Khalabat Town",
    "Khan Garh",
    "Khanewal",
    "Khanpur",
    "Khanpur(Skp",
    "Khanqah",
    "Khanqah Dograh",
    "Khar",
    "Kharan",
    "Kharian",
    "Khaur",
    "Khawaz Khela",
    "Khiderwala",
    "Khipro",
    "Khudian Khas",
    "Khurrian Wala",
    "Khuzdar",
    "Killi Karbala",
    "Kohar",
    "Kohat",
    "Kohat Township",
    "Kohlu",
    "Kot Addu",
    "Kot Digi",
    "Kot Ghulam Muhammad",
    "Kot Memon",
    "Kot Najeebullah",
    "Kot Qazi",
    "Kot Radha Kishan",
    "Kot Samaba",
    "Kotali Loharan",
    "Kotli(Azad Kashmir)",
    "Kotri City",
    "Kotta A.Ali Khan",
    "Kuchlak",
    "Kulachi",
    "Kullowal",
    "Kundian",
    "Kunjah",
    "Kunri",
    "Lachi",
    "Lahore",
    "Lakki Ghulam Shah",
    "Lalamusa",
    "Lalian",
    "Landi Kotal",
    "Larkana",
    "Latamber",
    "Layyah",
    "Liaqat Abad",
    "Liaqatpur",
    "Liliah Town",
    "Lodhran",
    "Lohi Bhar",
    "Loralie",
    "Lukky Marwat",
    "Machh",
    "Mailsi",
    "Mianwali Bangla",
    "Mukkuana",
    "Malhal Mughlan",
    "Malikwal",
    "Mamu Kanjan",
    "Mana More",
    "Manawala Town",
    "Mandi Bahuddin",
    "Mandi Dhaban Singh",
    "Mandi Faizabad",
    "Mandi Hira Singh",
    "Mandra",
    "Mangowal",
    "Mankera",
    "Mansehra",
    "Mardan",
    "Mathra",
    "Matiari",
    "Matli",
    "Matta",
    "Mattani",
    "Mustung",
    "Mehar",
    "Mehrab Pur",
    "Meilsi",
    "Mianwali",
    "Miawali Qureshian",
    "Minchanabad",
    "Mir Ali",
    "Mirpur (A.K)",
    "Miran Shah",
    "Mirpur Khas",
    "Miro Khan",
    "Mirpur Mathelo",
    "Mithan Kot",
    "Mithi",
    "More Emanabad",
    "More Khunda",
    "Moro",
    "Multan",
    "Murid Wala",
    "Murree",
    "Muslim Bagh",
    "Mustafa Abad",
    "Muzaffar Garh",
    "Muzaffarab",
    "Nala Kajori",
    "Nankana Sahib",
    "Narang Mandi",
    "Narowal",
    "Nasirabad",
    "Nathia Gali",
    "Naudero",
    "Naukot",
    "Naukundi",
    "Naushera Khushab",
    "Naushera Vikran",
    "Naushera Feroz",
    "Nawab Shah",
    "Nawagai",
    "Nawan Kali",
    "Nawan Lahore",
    "New Jatoi",
    "New Saeedabad",
    "Nika Jang",
    "Nizam Bazar",
    "Noor Shah",
    "Nooriabad",
    "Noorpur Thall",
    "Noshki",
    "Nowshera",
    "Ogoki",
    "Okara",
    "Ormarah",
    "Pabbi",
    "Pad Edan",
    "Padhana",
    "Pak Pattan",
    "Pano Aqil",
    "Pansera",
    "Panwan",
    "Parachinar",
    "Pasni",
    "Pasrur",
    "Pattoki",
    "Penyala",
    "Peshawar",
    "Pezo",
    "Phagwari",
    "Phalia",
    "Pinanwal",
    "Pindi Dadan Khan",
    "Pindi Bhatian",
    "Pindi Gheb",
    "Pir Jo Goth",
    "Pir Mahal",
    "Pir Pai",
    "Piryalo",
    "Pishin",
    "Pithoro",
    "Pull-iii",
    "Punjgoor",
    "Qabula",
    "Qalanderabad",
    "Qazi Ahmed",
    "Qila Saifullah",
    "Qila Sheikhupura",
    "Qila Suba Singh",
    "Quaid Abad",
    "Quetta",
    "Quetta Army Exch",
    "Quetta PAF",
    "Quetta Staff College",
    "Rabwah",
    "Radhan",
    "Raheemabad",
    "Rahim Yar Khan",
    "Rahwali",
    "Raiwind",
    "Raja Jang",
    "Rajan Pur",
    "Rajana",
    "Rangoonwaisa",
    "Rani Pur",
    "Rashakai",
    "Rattodero",
    "Rawalakot",
    "Rawalpindi",
    "Rawat",
    "Renala Khurd",
    "Risalpur",
    "Rizmak",
    "Rodala Road",
    "Rodu Sultan",
    "Rohilla Wali",
    "Rojhan",
    "Rojhan Jamali",
    "Rustam",
    "Sabirabad",
    "Sadda(KUrram Agency)",
    "Sadhoki",
    "Sadiqabad",
    "Sagri",
    "Sahiwal",
    "Sahiwal -SGD",
    "Saidu Sharif",
    "Sakardu",
    "Sakha Kot",
    "Sakrund",
    "Sambarial",
    "Samundri",
    "Sang Jani",
    "Sanghar",
    "Sangla Hill",
    "Sanjwani",
    "Sarai Naurang",
    "Sargodha",
    "Satiana",
    "Sehna",
    "Sehwan Sharif",
    "Shabqadar",
    "Shadi Khan",
    "Shadiwal",
    "Shah Jawani City",
    "Saha Jwanani Mandi",
    "Shah Kot",
    "Shah Pur Saddar",
    "Shahbaz Khel",
    "Shahdad Kot",
    "Shahdad Pur",
    "Shahpur Chakar",
    "Shakar Garh",
    "Sharq Pur",
    "Sheikh Manda",
    "Sher Garh",
    "Sherpao",
    "Shikar Pur",
    "Shinkiari",
    "Shorkot Cantt.",
    "Shuja Abad",
    "Sialkot",
    "Sibbi",
    "Sidh",
    "Sihala",
    "Sillaan Wali",
    "Sita Road",
    "Sobodero",
    "Sohawa",
    "Sodhra",
    "Sukheki",
    "Sujawal",
    "Sukkur",
    "Swabi",
    "Taftan",
    "Takht Bai",
    "Takht Nusrati",
    "Talagang",
    "Talhar",
    "Tall",
    "Talwandi Musa Khan",
    "Tandianwala",
    "Tando Adam",
    "Tando Allah Yar",
    "Tando Jam",
    "Tando Mohd. Khan",
    "Tank",
    "Taranda M.Pinah",
    "Tarlai Khan",
    "Tasp",
    "Tattli Aali",
    "Taunsa",
    "Taxila",
    "Thana",
    "Thana Bulla Khan",
    "Tharu Shah",
    "Thatta",
    "Thekri Wala",
    "Thorder",
    "Thul",
    "Timer Garah",
    "Toba Ttek Singh",
    "Topi",
    "Toru",
    "Tulamba",
    "Turbat",
    "Ubaro",
    "Uch Sharif",
    "Umer Kot",
    "Usta Muhammad",
    "Uthal",
    "Vehari",
    "Vehoa",
    "Wadh",
    "Wana",
    "Wana Radha Ram",
    "War Burton",
    "Warah",
    "Wari",
    "Wazirabad",
    "Yar Hussain",
    "Yazman",
    "Zaida",
    "Zarobi",
    "Zhob",
    "Ziarat"
]
struct AppFontName {
    static let circularStdRegular = "CircularStd-Book"
    static let circularStdBold = "CircularStd-Bold"
    static let robotoRegular = "Roboto-Regular"
    static let robotoMedium = "Roboto-Medium"
}




struct Message {
    static let logoutConfirmationMsg = "Are you sure you want to logout?"
    static let allPortfolio = "All Portfolios"
    static let MTPFPMessage = "Online Transactions of Pension Fund account are not possible' Please call 080042525 for details"
    static let fundNotAvaliable = "No Fund avaliable for selected Portfolio Id."
}
class Constant {
    
}

extension Constant {
    class ServiceConstant {
        // MARK: - PROPERTIES
        static let SETUP_API        =   "setup"
        static let CUSTOMER_LOGIN   =   "customerlogin"
        static let FOREX_SPOT       =   "ForexSpot"
        static let NAV_PERFORMANCE  =   "NavPerformance"
        static let NAV_HISTROY      =   "NavHistory"
        static let OTP_SEND         =   "OTPSendSSA"
        static let OTP_VERIFY       =   "OTPVerifySSA"
        static let BANK_LIST        =   "InvestmentBanks"
        static let SSA_SUBMISSION   =   "SSAAccount"
        static let RISK_PROFILE     =   "RpfCalculation"
        static let COUNTRY_CITY      =   "CountryCity"
        static let FUNDS_INVESTMENT = "AccountOpeningFundsSSA"
        static let ACCOUNT_OPENING_INVESTMENT = "AccountOpeningInvestment"
        static let BRANCH_LOCATOR       =   "BranchLocator"
        
        static let SURVEY_SUBMISSION = "NPSSurveySubmit"
        static let SURVEY_CANCEL = "NPSSurveyCancel"
        
        
        static let SERVICE_SUBCRIBED = "ServiceSubscribed"
        static let CUSTOMER_SERVICES_SUBSCRIPTION = "customerservicesubscription"
        
        
        static let PAYEE_LIST = "titlelist"
        static let PAYEE_HISTORY = "ibfthistory"
        static let FETCH_PAYEE_TITEL = "titlefetch"
        static let ADD_PAYEE = "titleadd"
        static let IBFT = "ibft"
        static let BANK_LIST_FOR_PAYEE = "banklist"
        
        static let BILLING_LIST = "billlist"
        static let BILLING_INQUIRY = "billInquiry"
        static let ADD_BILLING = "billadd"
        static let BILL_PAYMENT = "billpayment"
        static let BILL_MERCHANT_LIST = "billermerchant"
        static let BILL_HISTORY = "billpaymenthistory"
        
        static let OTP_VERIFICATION_PAYMENT = "otpverifypaymentservices"
    }
}


extension Constant {
    static var SSA_data: SSACNICData?
    static var setup_data: SetupModel?
    static var health_dec: HealthDec?
    static var joint_account: PersonalInfoEntity.JointHolder?
    static var banks: [BankInfoViewEntity.BankInfoResponseModel]?
    static var country : [Country]?
    class CustomerData {
        static var customer_data: OTPVerificationEntity.OTPVerificationResponseModel?
    }
}

