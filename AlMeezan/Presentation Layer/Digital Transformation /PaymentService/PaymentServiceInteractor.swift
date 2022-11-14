//
//  PaymentServiceInteractor.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 31/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class PaymentServiceInteractor: SubscriptionInteractorProtocol {
    
    var presenter: SubscriptionPresenterProtocol?
    let container = DependencyContainer()
    let worker: SubscriptionWorkerProtocol
    required init(worker: SubscriptionWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        getcustomerSubscription()
    }
    
    private func getcustomerSubscription() {
        let requestData = SubscriptionEntity.SubscriptionRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.serviceSubscribed(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: subscriptionResponse) in
                        self.presenter?.subscriptionResponse(dataResult)
                    }
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
                //self.presenter?.dataFailure(error: error.localizedDescription)

            }
        }
        
    }
    func saveSubscribed(data: subcribedRequest) {
        
    }


}
