import Foundation

struct CustomerDetail : Codable {
	let portfolio_ID : String?
	let customer_Name : String?
	let dt_AccountOpening : String?
	let f_Husband_Name : String?
	let address : String?
	let phone_Residence : String?
	let phone_Office : String?
	let mobile : String?
	let email : String?
	let oPERATIN_INSTRUCTIONS : String?
	let bANK_NAME : String?
	let bANK_BRANCH : String?
	let bANK_ACCOUNT_NO : String?
	let dIVIDEND_MANADATE : String?
	let dISP_MODE : String?
	let fMR_Subscription : String?
	let sMS_Subscription : String?
	let email_Subscription : String?
	let iS_ZAKAT_EXEMPT : String?
	let salePerson : String?
	let jointHolderName1 : String?
	let jointHolderName2 : String?
	let jointHolderName3 : String?

	enum CodingKeys: String, CodingKey {

		case portfolio_ID = "Portfolio_ID"
		case customer_Name = "Customer_Name"
		case dt_AccountOpening = "dt_AccountOpening"
		case f_Husband_Name = "F_Husband_Name"
		case address = "Address"
		case phone_Residence = "Phone_Residence"
		case phone_Office = "Phone_Office"
		case mobile = "Mobile"
		case email = "Email"
		case oPERATIN_INSTRUCTIONS = "OPERATIN_INSTRUCTIONS"
		case bANK_NAME = "BANK_NAME"
		case bANK_BRANCH = "BANK_BRANCH"
		case bANK_ACCOUNT_NO = "BANK_ACCOUNT_NO"
		case dIVIDEND_MANADATE = "DIVIDEND_MANADATE"
		case dISP_MODE = "DISP_MODE"
		case fMR_Subscription = "FMR_Subscription"
		case sMS_Subscription = "SMS_Subscription"
		case email_Subscription = "Email_Subscription"
		case iS_ZAKAT_EXEMPT = "IS_ZAKAT_EXEMPT"
		case salePerson = "SalePerson"
		case jointHolderName1 = "JointHolderName1"
		case jointHolderName2 = "JointHolderName2"
		case jointHolderName3 = "JointHolderName3"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		portfolio_ID = try values.decodeIfPresent(String.self, forKey: .portfolio_ID)
		customer_Name = try values.decodeIfPresent(String.self, forKey: .customer_Name)
		dt_AccountOpening = try values.decodeIfPresent(String.self, forKey: .dt_AccountOpening)
		f_Husband_Name = try values.decodeIfPresent(String.self, forKey: .f_Husband_Name)
		address = try values.decodeIfPresent(String.self, forKey: .address)
		phone_Residence = try values.decodeIfPresent(String.self, forKey: .phone_Residence)
		phone_Office = try values.decodeIfPresent(String.self, forKey: .phone_Office)
		mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		oPERATIN_INSTRUCTIONS = try values.decodeIfPresent(String.self, forKey: .oPERATIN_INSTRUCTIONS)
		bANK_NAME = try values.decodeIfPresent(String.self, forKey: .bANK_NAME)
		bANK_BRANCH = try values.decodeIfPresent(String.self, forKey: .bANK_BRANCH)
		bANK_ACCOUNT_NO = try values.decodeIfPresent(String.self, forKey: .bANK_ACCOUNT_NO)
		dIVIDEND_MANADATE = try values.decodeIfPresent(String.self, forKey: .dIVIDEND_MANADATE)
		dISP_MODE = try values.decodeIfPresent(String.self, forKey: .dISP_MODE)
		fMR_Subscription = try values.decodeIfPresent(String.self, forKey: .fMR_Subscription)
		sMS_Subscription = try values.decodeIfPresent(String.self, forKey: .sMS_Subscription)
		email_Subscription = try values.decodeIfPresent(String.self, forKey: .email_Subscription)
		iS_ZAKAT_EXEMPT = try values.decodeIfPresent(String.self, forKey: .iS_ZAKAT_EXEMPT)
		salePerson = try values.decodeIfPresent(String.self, forKey: .salePerson)
		jointHolderName1 = try values.decodeIfPresent(String.self, forKey: .jointHolderName1)
		jointHolderName2 = try values.decodeIfPresent(String.self, forKey: .jointHolderName2)
		jointHolderName3 = try values.decodeIfPresent(String.self, forKey: .jointHolderName3)
	}

}
