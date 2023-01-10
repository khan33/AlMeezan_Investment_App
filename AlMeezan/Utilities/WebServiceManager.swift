//
//  WebServiceManager.swift
//  AlMeezan
//
//  Created by Atta khan on 16/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CryptoSwift
import SVProgressHUD
import CoreData


class WebServiceManager: NSObject {
    static var serviceCount = 0
    static let sharedInstance = WebServiceManager()
    
    func getRequest<T: Mappable>(params: Dictionary<String, AnyObject>, url: URL, serviceType: String, modelType: T.Type, success: @escaping ( _ servicResponse: [T]) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool){
    
//        SVProgressHUD.show()
    showNetworkIndicator()
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
    let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
    
    Alamofire.request(request)
        .responseString { response in
            SVProgressHUD.dismiss()
            self.hideNetworkIndicator()
            switch(response.result) {
            case .success(_):
                if let data = response.result.value {
                    let value = data.replacingOccurrences(of: "\"", with: "")
                    print(value)
                    let dec = try! self.aesDecrypt(key: key, iv: iv, value)
                
                    let data = dec.data(using: .utf8)!
//                        let data1 = Data(dec.utf8)
//                        let user = try! JSONDecoder().decode(FundsDataModel.self, from: dataa)
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>] {
                            print(jsonArray)
                            
                            let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                .appendingPathComponent("Sample.json") // Your json file name
                            try? data.write(to: fileUrl)
                            
                            
                            
                            var data = Mapper<T>().mapArray(JSONArray: jsonArray)
                            
                            print(data)
                            success(data)
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
            case .failure(_):
                print("Error message:\(response.result.error)")
                break
            }
    }
}

    
    func fetchObject<D: Codable>(params: Dictionary<String, AnyObject>, url: URL, serviceType: String, modelType: D.Type, errorMessage: @escaping (_ errorResponse: [ErrorResponse]) -> Void, success: @escaping ( _ servicResponse: D) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool){
        showNetworkIndicator()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        
        Alamofire.request(request).validate(statusCode: 200..<300)
            .responseString { response in
                SVProgressHUD.dismiss()
                self.hideNetworkIndicator()
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        let value = data.replacingOccurrences(of: "\"", with: "")
                        print(value)
                        let dec = try! self.aesDecrypt(key: key, iv: iv, value)
                        let dataa = dec.data(using: .utf8)!
                        
                        if let JSONString = String(data: dataa, encoding: String.Encoding.utf8) {
                           print("Print JSON ", JSONString)
                        }
                        if serviceType != "Cache Data" {
                            let user = try! JSONDecoder().decode(D.self, from: dataa)
                            success(user)
                        } else {
                            do {
                                guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                                    fatalError("Failed to retrieve managed object context")
                                }
                                let managedObjectContext = persistence.context
                                let decoder = JSONDecoder()
                                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                                let user = try decoder.decode(D.self, from: dataa)
                                print(user)
                                try persistence.context.save()
                                success(user)
                            } catch let error {
                                print(error)
                            }
                            
                        }
                        
                        
                        
                        let errorID = try! JSONDecoder().decode(ErrorResponse.self, from: dataa)
                        errorMessage([errorID])
                        
                    }
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    fail(response.result.error as! NSError)
                    break
                }
        }
        
    }
   
    func fetch<D: Codable>(params: Dictionary<String, AnyObject>, url: URL, serviceType: String, modelType: D.Type, errorMessage: @escaping (_ errorResponse: [ErrorResponse]) -> Void, success: @escaping ( _ servicResponse: [D]) -> Void, fail: @escaping ( _ error: NSError) -> Void, showHUD: Bool) {
        
        showNetworkIndicator()
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue);
        
        Alamofire.request(request).validate(statusCode: 200..<300)
            .responseString { response in
                self.hideNetworkIndicator()
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        let value = data.replacingOccurrences(of: "\"", with: "")
                        let dec = try! self.aesDecrypt(key: key, iv: iv, value)
                        
                        let dataa = dec.data(using: .utf8)!
                        
                        //print("Decrypted value is = ", dataa)
                        if let JSONString = String(data: dataa, encoding: String.Encoding.utf8) {
                           print("JSON return = ", JSONString)
                        }
                        if serviceType != "Cache Data" {
                            do {
                                let user = try JSONDecoder().decode(Array<D>.self, from: dataa)
                                SVProgressHUD.dismiss()
                                success(user)
                            } catch {
                                print("Error message:\(error))")
                            }
                            
                        }
                        else {
                            do {
                                guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                                    fatalError("Failed to retrieve managed object context")
                                }
                                persistence.clearEntityData(D.self as! (NSManagedObject.Type))
                                let managedObjectContext = persistence.context
                                let decoder = JSONDecoder()
                                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                                let user = try decoder.decode([D].self, from: dataa)
                                //print(user)
                                try persistence.context.save()
                                SVProgressHUD.dismiss()
                                success(user)
                            } catch let error {
                                
                                print(error)
                            }
                        }
                        
                        do {
                             let errorID = try JSONDecoder().decode(Array<ErrorResponse>.self, from: dataa)
                              errorMessage(errorID)
                        } catch {
                            print("Error message:\(error))")
                        }
                       
                        
                    }
                case .failure(_):
                    SVProgressHUD.dismiss()
                    print("Error message:\(String(describing: response.result.error))")
                    fail(response.result.error as! NSError)
                    break
                }
        }
    }
    
    func aesDecrypt(key: String, iv: String, _ decrptyData: String) throws -> String {
        guard let data = Data(base64Encoded: decrptyData) else { return "" }
        let decrypted = try! AES(key: key, iv: iv, padding: .pkcs7).decrypt([UInt8](data))
        let decryptedData = Data(decrypted)
        return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
    }
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data: Data = tmpString.data(using: .utf8)!
        let encrypted = try AES(key: key, iv: iv, padding: .pkcs7).encrypt((data.bytes))
        let encData = Data(bytes: encrypted, count: encrypted.count)
        let base64str = encData.base64EncodedString(options: .init(rawValue: 0))
        let result = String(base64str)
        return result
    }
    
    
    func showNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        WebServiceManager.serviceCount += 1
    }
    
    func hideNetworkIndicator() {
        WebServiceManager.serviceCount -= 1
        if WebServiceManager.serviceCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


struct ResponseModel<T: Codable>: Codable {
    
    // MARK: - Properties
    var targetUrl: String?
    var success: Bool
    var unAuthorizedRequest: String?
    var abp: Bool = false
    
    
    var isSuccess: Bool
    var message: String
    var error: ErrorModel {
        return ErrorModel(message)
    }
    var rawData: Data?
    var data: T?
    var result: T?
    var json: String? {
        guard let rawData = rawData else { return nil }
        return String(data: rawData, encoding: String.Encoding.utf8)
    }
    var request: RequestModel?

    init() {
        self.isSuccess = false
        self.message = ""
        self.success = false
    }
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        success = (try? keyedContainer.decode(Bool.self, forKey: CodingKeys.success)) ?? false
        isSuccess = (try? keyedContainer.decode(Bool.self, forKey: CodingKeys.isSuccess)) ?? false
        message = (try? keyedContainer.decode(String.self, forKey: CodingKeys.message)) ?? ""
        data = try? keyedContainer.decode(T.self, forKey: CodingKeys.data)
        result = try? keyedContainer.decode(T.self, forKey: CodingKeys.result)
        abp = (try? keyedContainer.decode(Bool.self, forKey: CodingKeys.success)) ?? false
    }
}

// MARK: - Private Functions
extension ResponseModel {

    private enum CodingKeys: String, CodingKey {
        case isSuccess
        case message
        case data
        case result
        case targetUrl
        case success
        case unAuthorizedRequest
        case abp = "__abp"
    }
}
