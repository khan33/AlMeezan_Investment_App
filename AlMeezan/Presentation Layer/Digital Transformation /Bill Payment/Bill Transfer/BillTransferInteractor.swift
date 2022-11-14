//
//  BillTransferInteractor.swift
//  AlMeezan
//
//  Created by Ahmad on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillTransferInteractor: BillTransferInteractorProtocol {

    var presenter: BillTransferPresenterProtocol?
    let container = DependencyContainer()
    let worker: BillTransferWorkerProtocol
    required init(worker: BillTransferWorkerProtocol) {
        self.worker = worker
    }
    
    func saveBillPayment(request: BillTransferEntity.BillTransferRequest) {
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billPayment(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: [BillTransferEntity.BillTransferResponse]) in
                        self.presenter?.setupBillPayment(response: dataResult)
                        print("Data is \(data)")
                    }
                }
            case .failure(let error):
                self.presenter?.showServerErrorMessage(error: error.localizedDescription)
            }
        }
    }
    
}
