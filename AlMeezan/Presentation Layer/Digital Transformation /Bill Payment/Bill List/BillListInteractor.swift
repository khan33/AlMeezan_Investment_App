//
//  Interactor.swift
//  AlMeezan
//
//  Created by Ahmad on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillListInteractor: BillListInteractorProtocol {
    
    var presenter: BillListPresenterProtocol?
    let container = DependencyContainer()
    let worker: BillListWorkerPrtocol
    required init(worker: BillListWorkerPrtocol) {
        self.worker = worker
    }
    
    func loadBillList() {
        let requestData = BillListEntity.BillListRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.setupBillList(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: [BillListEntity.BillListResponse]) in
                        self.presenter?.setupBillList(response: dataResult)
                        print("Data is \(data)")
                    }
                }
            case .failure(let error):
                self.presenter?.showServerErrorMessage(error: error.localizedDescription)
            }
        }
    }
    
    func loadHistoryList() {
        let requestData = HistoryListEntity.HistoryListRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billHistoryList(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: [FundTransferEntity.PayeeHistroyModel]) in
                        self.presenter?.billHistoryList(response: dataResult)
                        print("Data is \(data)")
                    }
                }
            case .failure(let error):
                self.presenter?.showServerErrorMessage(error: error.localizedDescription)
            }
        }
    }
}
