/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct Transactions : Codable {
	let portfolioId : String?
	let dealdate : String?
	let mnumenic : String?
	let transDesc : String?
	let units : Double?
	let amount : Double?
	let status : String?
	let channel : String?

	enum CodingKeys: String, CodingKey {

		case portfolioId = "PortfolioId"
		case dealdate = "dealdate"
		case mnumenic = "mnumenic"
		case transDesc = "TransDesc"
		case units = "Units"
		case amount = "Amount"
		case status = "Status"
		case channel = "Channel"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		portfolioId = try values.decodeIfPresent(String.self, forKey: .portfolioId)
		dealdate = try values.decodeIfPresent(String.self, forKey: .dealdate)
		mnumenic = try values.decodeIfPresent(String.self, forKey: .mnumenic)
		transDesc = try values.decodeIfPresent(String.self, forKey: .transDesc)
		units = try values.decodeIfPresent(Double.self, forKey: .units)
		amount = try values.decodeIfPresent(Double.self, forKey: .amount)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		channel = try values.decodeIfPresent(String.self, forKey: .channel)
	}

}