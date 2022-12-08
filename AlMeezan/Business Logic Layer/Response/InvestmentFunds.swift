/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct InvestmentFunds : Codable {
	let fundCategory : String?
	let funds : [Funds]?

	enum CodingKeys: String, CodingKey {

		case fundCategory = "FundCategory"
		case funds = "Funds"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		fundCategory = try values.decodeIfPresent(String.self, forKey: .fundCategory)
		funds = try values.decodeIfPresent([Funds].self, forKey: .funds)
	}

}

struct RestrictSeries: Codable {
    var restrictedSeries: [RestrictedId]
}

// MARK: - RestrictedSery
struct RestrictedId: Codable {
    var id: String

    enum CodingKeys: String, CodingKey {
        case id = "Id"
    }
}

struct VpsInvestment: Codable {
    let fundCategory: String
    var funds: [Fund]?

    enum CodingKeys: String, CodingKey {
        case fundCategory = "FundCategory"
        case funds = "Funds"
    }
}

// MARK: - Fund
struct Fund: Codable {
    let portfolioID, fundID, agentID, fundName: String?
    let category: String?
    let ord, type: Int?
    var isHighRisk: Int?

    enum CodingKeys: String, CodingKey {
        case portfolioID = "Portfolio_ID"
        case fundID = "FundID"
        case agentID = "AgentID"
        case fundName = "FundName"
        case category = "Category"
        case ord = "Ord"
        case type = "Type"
        case isHighRisk = "isHighRisk"
    }
}
