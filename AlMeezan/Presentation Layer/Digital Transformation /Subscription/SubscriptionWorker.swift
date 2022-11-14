//
//  SubscriptionWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class SubscriptionWorker: SubscriptionWorkerProtocol {
    
    func serviceSubscribed(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SubscriptionEntity.SubscriptionRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    func customerServiceSubscription(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SubscriptionEntity.SaveSubscriptionRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    
}
