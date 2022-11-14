//
//  ServiceManager.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


class ServiceManager: NSObject {
    // MARK: - Properties
    static let shared: ServiceManager = ServiceManager()
//    var baseURL: String = "https://members.almeezangroup.com/webapitest/api/"
    var baseURL: String = BASE_URL
    

}

extension ServiceManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            guard let serverTrust = challenge.protectionSpace.serverTrust else {
                completionHandler(.cancelAuthenticationChallenge, nil);
                return
            }
            
            let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
            
        
            // SSL Policies for domain name check
            let policy = NSMutableArray()
            policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
            
            //evaluate server certifiacte
            let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
            
            //Local and Remote certificate Data
            let remoteCertificateData:NSData =  SecCertificateCopyData(certificate!)
            
            let pathToCertificate = Bundle.main.path(forResource: "almeezangroupcerssl", ofType: "cer")
            let localCertificateData:NSData = NSData(contentsOfFile: pathToCertificate!)!
            //Compare certificates
            if(isServerTrusted && remoteCertificateData.isEqual(to: localCertificateData as Data)){
                let credential:URLCredential =  URLCredential(trust:serverTrust)
                print("Certificate pinning is successfully completed")
                completionHandler(.useCredential,nil)
            }
            else {
                DispatchQueue.main.async {
                    print("SSL Pinning failed....")
                    //self.showAlert(text: "SSL Pinning", message: "Pinning failed")
                }
                completionHandler(.cancelAuthenticationChallenge,nil)
            }
        }
}

// MARK: - Public Functions
extension ServiceManager {

    func sendRequest(request: RequestModel, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        if request.isLoggingEnabled.0 {
            LogManager.req(request)
        }
        var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        URLSession.shared.dataTask(with: request.urlRequest()) { data, response, error in
            
            guard response != nil else {
                completion(Result.failure(error as! Error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print(response)
                //completion(Result.failure(response))
                return
            }
            
            
            
            guard let data = data, let responseString = String.init(data: data, encoding: String.Encoding.utf8) else {
                let error: ErrorModel = ErrorModel(ErrorKey.parsing.rawValue)
                LogManager.err(error)
                completion(Result.failure(error))
                return
            }
            let value = responseString.replacingOccurrences(of: "\"", with: "")
            print("================Request Respnse ========================")
            print(value)
            print("========================================")
            completion(Result.success(value))
        }.resume()
    }
}
enum AppRepsone {
    case error(CZError)
}
enum CZError {
    case cannotDecode // Handle ComminDate
    case noInternet // ---
    case error(String) // Error.Description
    case tokenExpire // 401
    case validateInputs // 412
    case badUrl // 400
    case forbiden // 403
    case internalServerError // 500
    case cannotDecodeItem(String)
    case timeOut
    var description: String {
        switch self {
        case let .cannotDecodeItem(key):
            return "cannotDecode + \(key)"
        case .cannotDecode:
            return "cannotDecode"
        case .noInternet:
            return "noInternet"
        case let .error(err):
            return err
        case .tokenExpire:
            return "tokenExpire"
        case .validateInputs:
            return "validateInputs"
        case .badUrl:
            return "badUrl"
        case .forbiden:
            return "forbiden"
        case .internalServerError:
            return "internalServerError"
        case .timeOut:
            return "timeOut"
        }
    }
}
