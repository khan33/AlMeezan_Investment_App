//
//  BillWorker.swift
//  AlMeezan
//
//  Created by Ahmad on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillTransferWorker: BillTransferWorkerProtocol {
    func billPayment(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillTransferEntity.BillTransferRequestModel(KeyValue: encryptedString)) { result in
            completion(result)
        }
    }
    
}
