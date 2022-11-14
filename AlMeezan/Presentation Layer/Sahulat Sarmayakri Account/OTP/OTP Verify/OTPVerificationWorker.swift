//
//  OTPVerificationWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 03/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class OTPVerificationWorker: OTPVerificationWorkerProtocol {
    func VerifyOTP(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: OTPVerificationEntity.OTPVerificationRequestModel(KeyValue: encryptedString)) { response in
            
            completion(response)
        }
    }
    func generateOTP(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: OTPViewControllerEntity.OTPViewControllerRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
}
