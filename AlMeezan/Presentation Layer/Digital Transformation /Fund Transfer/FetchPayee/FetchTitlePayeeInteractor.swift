//
//  AddPayeeValiateInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 29/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class FetchTitlePayeeInteractor: FetchTitlePayeeInteractorProtocol {
    var presenter: FetchTitlePayeePresenterProtocol?
    let container = DependencyContainer()
    let worker: FundTransferWorkerProtocol
    required init(worker: FundTransferWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        bankList()
    }

    func fetchTitlePayee(_ data: fetchTitleRequest) {
        let jsonString = container.createCodeableManger().encodeToString(from: data)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.fetchPayeeTitle(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: fetchTitleResponse ) in
                        print(result)
                        self.presenter?.fetchTitleResponse(result)
                    }
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func bankList() {
        let requestData = FundTransferEntity.BankListRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.getBankList(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [BankInfoViewEntity.BankInfoResponseModel] ) in
                        print(result)
                        self.presenter?.bankList(result)
//                        self.presenter?.getPayeeList(result)
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
