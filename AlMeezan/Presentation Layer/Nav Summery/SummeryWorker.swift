//
//  SummeryWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class SummeryWorker: SummeryWorkerProtocol {
    func fetchFundSummery(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SummeryEntity.SummeryRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
}
