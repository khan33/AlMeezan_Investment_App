//
//  BillPaymentWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class BillPaymentWorker: BillPaymentWorkerProtocol {
    
    func billListRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillPaymentEntity.BillingRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    func billInquiryRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillPaymentEntity.BillInquiryRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func billPaymentRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillPaymentEntity.BillPaymentRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
 
    func billMerchantRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillPaymentEntity.BillMerchantRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func addBillRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillPaymentEntity.AddBillRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
}
