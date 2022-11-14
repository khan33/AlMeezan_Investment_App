/* 
Copyright (c) 2022 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Fatca : Codable {
	let accountTitle : String?
	let countryOfTaxResidence : String?
	let pobCity : String?
	let pobState : String?
	let pobCountry : String?
	let areYouUsCitizen : Bool?
	let areYouUsResident : Bool?
	let holdGreenCard : Bool?
	let whereBornInUsa : Bool?
	let accountMaintainedInUsa : Bool?
	let powerOfAttorney : Bool?
	let usResidenceMailiingAddress : Bool?
	let usTelephoneNumber : Bool?
	let cnic : String?
	let accountType : String?

	enum CodingKeys: String, CodingKey {

		case accountTitle = "AccountTitle"
		case countryOfTaxResidence = "CountryOfTaxResidence"
		case pobCity = "PobCity"
		case pobState = "PobState"
		case pobCountry = "PobCountry"
		case areYouUsCitizen = "areYouUsCitizen"
		case areYouUsResident = "areYouUsResident"
		case holdGreenCard = "holdGreenCard"
		case whereBornInUsa = "whereBornInUsa"
		case accountMaintainedInUsa = "accountMaintainedInUsa"
		case powerOfAttorney = "powerOfAttorney"
		case usResidenceMailiingAddress = "UsResidenceMailiingAddress"
		case usTelephoneNumber = "UsTelephoneNumber"
		case cnic = "Cnic"
		case accountType = "AccountType"
	}
}
