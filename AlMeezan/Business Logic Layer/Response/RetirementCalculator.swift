/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct RetirementCalculator : Codable {
	let currentAge : Int?
	let workingYear : Int?
	let allocationScheme : String?
	let totalContribution : Double?
	let balanceAtRetirement : Double?
	let withdrawAtRetirement : Double?
	let totalAmountInvested : Double?
	let iPPMonthlyPayment : Double?

	enum CodingKeys: String, CodingKey {

		case currentAge = "CurrentAge"
		case workingYear = "WorkingYear"
		case allocationScheme = "AllocationScheme"
		case totalContribution = "TotalContribution"
		case balanceAtRetirement = "BalanceAtRetirement"
		case withdrawAtRetirement = "WithdrawAtRetirement"
		case totalAmountInvested = "TotalAmountInvested"
		case iPPMonthlyPayment = "IPPMonthlyPayment"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		currentAge = try values.decodeIfPresent(Int.self, forKey: .currentAge)
		workingYear = try values.decodeIfPresent(Int.self, forKey: .workingYear)
		allocationScheme = try values.decodeIfPresent(String.self, forKey: .allocationScheme)
		totalContribution = try values.decodeIfPresent(Double.self, forKey: .totalContribution)
		balanceAtRetirement = try values.decodeIfPresent(Double.self, forKey: .balanceAtRetirement)
		withdrawAtRetirement = try values.decodeIfPresent(Double.self, forKey: .withdrawAtRetirement)
		totalAmountInvested = try values.decodeIfPresent(Double.self, forKey: .totalAmountInvested)
		iPPMonthlyPayment = try values.decodeIfPresent(Double.self, forKey: .iPPMonthlyPayment)
	}

}
