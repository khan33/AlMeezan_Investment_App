//
//  LoginWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 10/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation



class LoginWorker: LoginWorkerProtocol {
    func login(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        ServiceManager.shared.sendRequest(request: LoginEntity.LoginRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
        
    }
    
    func saveUserId(_ id: Int) {
        UserDefaults.standard.setValue(id, forKey: "userId")
    }
    
    func saveUserToken(_ token: String) {
        UserDefaults.standard.setValue(token, forKey: "token")
    }
    
    func getUserID() -> Int {
        return UserDefaults.standard.integer(forKey: "userId")
        
    }
    func getUserToken() -> String? {
        return UserDefaults.standard.string(forKey: "token")
    }
    
    
    
    
    
}
