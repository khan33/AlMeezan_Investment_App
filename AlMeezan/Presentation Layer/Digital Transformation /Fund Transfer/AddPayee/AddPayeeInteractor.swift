//
//  AddPayeeInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 20/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class AddPayeeInteractor: AddPayeeInteractorProtocol {
    var presenter: AddPayeePresenterProtocol?
    let container = DependencyContainer()
    let worker: FundTransferWorkerProtocol
    required init(worker: FundTransferWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        
    }

    func addPayee(_ data: addPayeeRequestData) {
        let jsonString = container.createCodeableManger().encodeToString(from: data)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.addPayee(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [FundTransferEntity.AddPayeeResponseModel] ) in
                        self.presenter?.addPayee(result)
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
