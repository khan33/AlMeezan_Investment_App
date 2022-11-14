//
//  PaymentInteractor.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class PaymentInteractor: PaymentInteractorProtocol {
    var presenter: PaymentPresenterProtocol?
    let container = DependencyContainer()
    let worker: FundTransferWorkerProtocol
    required init(worker: FundTransferWorkerProtocol) {
        self.worker = worker
    }
    
    func payPayment(_ reqeust: FundTransferEntity.FundTransferRequest) {
        let jsonString = container.createCodeableManger().encodeToString(from: reqeust)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.fundTransfer(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [FundTransferEntity.IBFTResponseModel] ) in
                        self.presenter?.paymentResponse(result)
                    }
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
