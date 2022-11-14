//
//  CodableHelper.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

protocol CodableHelperProtocol {
    func decodeObject<T: Decodable>(_ data: Data, isCaching: Bool, completion: @escaping ((T) -> Void))
    func decodeArray<T: Decodable>(_ data: Data, isCaching: Bool, completion: @escaping (([T]) -> Void))
    func encodeToString<T: Encodable>(from data : T) -> String
}



class CodableHelper: CodableHelperProtocol {
    func decodeArray<T: Decodable>(_ data: Data, isCaching: Bool ,completion: @escaping (([T]) -> Void)) {
        let decode = JSONDecoder()
        do {
            if isCaching {
                persistence.dataSaveIntoPresistance(decoder: decode,  modelType: T.self)
            }
            let model = try decode.decode([T].self, from: data)
            completion(model)
        } catch {
            print(error.localizedDescription)
        }
    }
    func decodeObject<T: Decodable>(_ data: Data, isCaching: Bool ,completion: @escaping ((T) -> Void)) {
        let decode = JSONDecoder()
        do {
            if isCaching {
                persistence.dataSaveIntoPresistance(decoder: decode,  modelType: T.self)
            }
            let model = try decode.decode(T.self, from: data)
            completion(model)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func encodeToString<T: Encodable>(from data: T) -> String  {
        let encode = JSONEncoder()
        do {
            let jsonData = try encode.encode(data)
            var jsonString = String(data: jsonData, encoding: .utf8)!
            if jsonString.contains("\\/") {
                jsonString = jsonString.replacingOccurrences(of: "\\/", with: "/", options: NSString.CompareOptions.literal, range: nil)
            }
            return jsonString
            
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }
    
}


enum SingleMulipleResult<T> {
  case single(T)
  case multiple([T])
  case error
}
