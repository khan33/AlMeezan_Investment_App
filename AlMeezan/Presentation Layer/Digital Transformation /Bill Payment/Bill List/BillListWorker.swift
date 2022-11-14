//
//  Worker.swift
//  AlMeezan
//
//  Created by Ahmad on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillListWorker: BillListWorkerPrtocol {
    
    func setupBillList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: BillListEntity.BillListRequestModel(KeyValue: encryptedString)) { result in
            completion(result)
        }
    }
    
    func billHistoryList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: HistoryListEntity.HistoryListRequestModel(KeyValue: encryptedString)) { result in
            completion(result)
        }
    }
}
