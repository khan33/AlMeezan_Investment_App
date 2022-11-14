//
//  PayeeInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation



class PayeeInteractor: PayeeInteractorProtocol {
    var presenter: PayeePresenterProtocol?
    let container = DependencyContainer()
    let worker: FundTransferWorkerProtocol
    required init(worker: FundTransferWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        PayeeList()
        fetchPayeeHistory()
    }

    private func PayeeList() {
        let requestData = FundTransferEntity.PayeeRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.payeeList(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: payeeListResponse ) in
                        print(result)
                        self.presenter?.getPayeeList(result)
                    }
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
    func fetchPayeeTitle(_ request: fetchTitleRequest) {
        
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.fetchPayeeTitle(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    print(data)
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchPayeeHistory() {
        let request = FundTransferEntity.PayeeHistoryRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.fetchPayeeHistory(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: payeeHistoryResponse ) in
                        self.presenter?.getPayeeHistoryList(result)
                    }
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func addPayee(_ data: addPayeeRequestData) {
        let jsonString = container.createCodeableManger().encodeToString(from: data)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.addPayee(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    print(data)
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
                    print(data)
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fundTransfer(_ data: fundTransferData) {
        let jsonString = container.createCodeableManger().encodeToString(from: data)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.fundTransfer(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    print(data)
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    
}
