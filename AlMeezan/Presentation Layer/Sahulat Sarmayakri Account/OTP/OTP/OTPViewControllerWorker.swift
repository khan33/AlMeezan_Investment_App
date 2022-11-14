//
//  OTPViewControllerWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class OTPViewControllerWorker: OTPViewControllerWorkerProtocol {
    func setUpData(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SetUpRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func generateOTP(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: OTPViewControllerEntity.OTPViewControllerRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func verifyOTP() {
        
    }
    
    
    
}
