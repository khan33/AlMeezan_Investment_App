//
//  AddBillWorker.swift
//  AlMeezan
//
//  Created by Ahmad on 30/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
class AddBillWorker: AddBillWorkerProtocol {
    func billAdd(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillAddEntity.BillAddRequestModel(KeyValue: encryptedString)) { result in
            completion(result)
        }
    }
    
    func billInquiry(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillInquiryEntity.BillInquiryRequestModel(KeyValue: encryptedString)) { result in
            completion(result)
        }
    }
    
    func addBillMerchantList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: AddBillEntity.AddBillRequestModel(KeyValue: encryptedString)) { result in
            completion(result)
        }
    }

}
