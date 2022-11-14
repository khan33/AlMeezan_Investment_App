/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import CoreData

@objc(KIBORDelayModel)
class KIBORDelayModel : NSManagedObject ,Codable {
	@NSManaged var tenor : String?
	@NSManaged var days : Int16
	@NSManaged var bid : Float
	@NSManaged var ask : Float
	@NSManaged var dateTime : String?
	@NSManaged var entryTime : String?

	enum CodingKeys: String, CodingKey {

		case tenor = "Tenor"
		case days = "Days"
		case bid = "Bid"
		case ask = "Ask"
		case dateTime = "DateTime"
		case entryTime = "EntryTime"
	}

    
    
	required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
            let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "KIBORDelayModel", in: managedObjectContext) else {
            fatalError("Failed to decode Companies")
        }
         self.init(entity: entity, insertInto: managedObjectContext)
		let values = try decoder.container(keyedBy: CodingKeys.self)
		tenor = try values.decodeIfPresent(String.self, forKey: .tenor)
        days = try (values.decodeIfPresent(Int16.self, forKey: .days) ?? 0)
        bid = try (values.decodeIfPresent(Float.self, forKey: .bid) ?? 0.0)
        ask = try (values.decodeIfPresent(Float.self, forKey: .ask) ?? 0.0)
		dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime)
		entryTime = try values.decodeIfPresent(String.self, forKey: .entryTime)
	}
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tenor, forKey: .tenor)
        try container.encode(days, forKey: .days)
        try container.encode(bid, forKey: .bid)
        try container.encode(ask, forKey: .ask)
        try container.encode(dateTime, forKey: .dateTime)
        try container.encode(entryTime, forKey: .entryTime)
        
    }

}
