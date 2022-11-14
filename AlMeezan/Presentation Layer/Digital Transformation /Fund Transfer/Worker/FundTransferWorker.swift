//
//  FundTransferWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class FundTransferWorker: FundTransferWorkerProtocol {
    
    func getBankList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void){
        ServiceManager.shared.sendRequest(request: FundTransferEntity.BankListRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    func fetchPayeeTitle(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void){
        ServiceManager.shared.sendRequest(request: FundTransferEntity.FetchPayeeTitleRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func fetchPayeeHistory(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void){
        ServiceManager.shared.sendRequest(request: FundTransferEntity.PayeeHistoryRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func addPayee(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void){
        ServiceManager.shared.sendRequest(request: FundTransferEntity.AddPayeeRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    func payeeList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void){
        ServiceManager.shared.sendRequest(request: FundTransferEntity.PayeeRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    func fundTransfer(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void){
        ServiceManager.shared.sendRequest(request: FundTransferEntity.IBFTRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    func OTPVerification(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void){
        ServiceManager.shared.sendRequest(request: FundTransferEntity.OTPVerificationRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    
}
