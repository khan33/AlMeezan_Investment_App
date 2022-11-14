//
//  RequestModel.swift
//  AlMeezan
//
//  Created by Atta khan on 09/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
class RequestModel: NSObject {
    
    // MARK: - properties
    
    var path: String {
        return ""
    }
    
    
    var parameters: [String: Any?] {
        return [:]
    }
    
    
    var headers: [String: String] {
        return [:]
    }
    
    var body: [String: Any?] {
        return [:]
    }
    
    
    var method: RequestHTTPMethod {
        return body.isEmpty ? RequestHTTPMethod.get : RequestHTTPMethod.post
    }
    

    var isLoggingEnabled: ( Bool, Bool ) {
        return (true, true)
    }
    
    
}
enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


// MARK: - Public Functions

extension RequestModel {
    
    func urlRequest() -> URLRequest { 
        var endPoint = ServiceManager.shared.baseURL.appending(path)

        for parameter in parameters {

            if let value = parameter.value as? String {
                print(value)
                endPoint.append("?\(parameter.key)=\(value)")
            }
        }

        var request: URLRequest = URLRequest(url: URL(string: endPoint)!)
        request.httpMethod = method.rawValue

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
            
        }

        
        if method == RequestHTTPMethod.post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch let error {
                print(error)
            }
        }
        return request
        
    }
    
}
