/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Kyc : Codable {
	let residentialStatus : String?
	let sourceOfIncome : String?
	let sourceOfWealth : String?
	let nameOfEmployer : String?
	let designation : String?
	let natureOfBusiness : String?
	let education : String?
	let profession : String?
	let geographiesDomestic : String?
	let geographiesIntl : String?
	let counterPartyDomestic : String?
	let counterPartyIntl : String?
	let modeOfTransaction : String?
	let numberOfTransaction : String?
	let expectedTurnOverMonthlyAnnual : String?
	let expectedTurnOver : String?
	let expectedInvestmentAmount : String?
	let annualIncome : String?
	let actionOnBehalfOfOther : Bool?
	let refusedYourAccount : Bool?
	let seniorPositionInGovtInstitute : Bool?
	let seniorPositionInPoliticalParty : Bool?
	let financiallyDependent : Bool?
	let highValueGoldSilverDiamond : Bool?
	let incomeIsHighRisk : Bool?
	let headOfState : Bool?
	let seniorMilitaryOfficer : Bool?
	let headOfDeptOrIntlOrg : Bool?
	let memberOfBoard : Bool?
	let memberOfNationalSenate : Bool?
	let politicalPartyOfficials : Bool?
	let pep_Declaration : String?
	let whereDidYouHearAboutUs : String?
	let daoID : String?
	let cnic : String?
	let accountType : String?

	enum CodingKeys: String, CodingKey {

		case residentialStatus = "ResidentialStatus"
		case sourceOfIncome = "SourceOfIncome"
		case sourceOfWealth = "SourceOfWealth"
		case nameOfEmployer = "NameOfEmployer"
		case designation = "Designation"
		case natureOfBusiness = "NatureOfBusiness"
		case education = "Education"
		case profession = "Profession"
		case geographiesDomestic = "GeographiesDomestic"
		case geographiesIntl = "GeographiesIntl"
		case counterPartyDomestic = "CounterPartyDomestic"
		case counterPartyIntl = "CounterPartyIntl"
		case modeOfTransaction = "ModeOfTransaction"
		case numberOfTransaction = "NumberOfTransaction"
		case expectedTurnOverMonthlyAnnual = "ExpectedTurnOverMonthlyAnnual"
		case expectedTurnOver = "ExpectedTurnOver"
		case expectedInvestmentAmount = "ExpectedInvestmentAmount"
		case annualIncome = "AnnualIncome"
		case actionOnBehalfOfOther = "actionOnBehalfOfOther"
		case refusedYourAccount = "refusedYourAccount"
		case seniorPositionInGovtInstitute = "seniorPositionInGovtInstitute"
		case seniorPositionInPoliticalParty = "seniorPositionInPoliticalParty"
		case financiallyDependent = "financiallyDependent"
		case highValueGoldSilverDiamond = "highValueGoldSilverDiamond"
		case incomeIsHighRisk = "incomeIsHighRisk"
		case headOfState = "headOfState"
		case seniorMilitaryOfficer = "seniorMilitaryOfficer"
		case headOfDeptOrIntlOrg = "headOfDeptOrIntlOrg"
		case memberOfBoard = "memberOfBoard"
		case memberOfNationalSenate = "memberOfNationalSenate"
		case politicalPartyOfficials = "politicalPartyOfficials"
		case pep_Declaration = "Pep_Declaration"
		case whereDidYouHearAboutUs = "WhereDidYouHearAboutUs"
		case daoID = "DaoID"
		case cnic = "Cnic"
		case accountType = "AccountType"
	}

}
