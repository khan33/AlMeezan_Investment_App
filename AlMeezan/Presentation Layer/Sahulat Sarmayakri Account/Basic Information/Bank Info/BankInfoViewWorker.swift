//
//  BankInfoViewWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 12/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BankInfoViewWorker: BankInfoWorkerProtocol {
    func getBankInfo(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BankInfoViewEntity.BankInfoRequestModel(KeyValue: encryptedString )) { response in
            completion(response)
        }
    }
    
    
    func submitApi(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SubmissionSSARequestModel(KeyValue: encryptedString )) { response in
            completion(response)
        }
    }
    
    
    func calculateRisk(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: RiskProfileEntity.RiskProfileRequestModel(KeyValue: encryptedString )) { response in
            completion(response)
        }
    }
    func getCountry(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: CountryRequestModel(KeyValue: encryptedString )) { response in
            completion(response)
        }
    }
    
    func getBranchCity(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BranchRequestModel(KeyValue: encryptedString )) { response in
            completion(response)
        }
    }
}
