//
//  AddBillInteractor.swift
//  AlMeezan
//
//  Created by Ahmad on 30/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class AddBillInteractor: AddBillInteractorProtocol {

    var presenter: AddBillPresenterProtocol?
    let container = DependencyContainer()
    let worker: AddBillWorkerProtocol
    required init(worker: AddBillWorkerProtocol) {
        self.worker = worker
    }
    
    func loadAddMerchandBill() {
        let requestData = AddBillEntity.AddBillRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.addBillMerchantList(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: [AddBillEntity.AddBillResponse]) in
                        self.presenter?.setupAddBillMerchantList(response: dataResult)
                        print("Data is \(data)")
                    }
                }
            case .failure(let error):
                self.presenter?.showServerErrorMessage(error: error.localizedDescription)
            }
        }
    }
    
    func loadBillInquiry(request: BillInquiryEntity.BillInquiryRequest) {
       // let requestData = AddBillEntity.AddBillRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billInquiry(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: [BillInquiryEntity.BillInquiryResponse]) in
                        self.presenter?.setupBillInquiry(response: dataResult)
                        print("Data is \(data)")
                    }
                }
            case .failure(let error):
                self.presenter?.showServerErrorMessage(error: error.localizedDescription)
            }
        }
    }
    func saveBillAdd(request: BillAddEntity.BillAddRequest) {
        // let requestData = AddBillEntity.AddBillRequest()
         let jsonString = container.createCodeableManger().encodeToString(from: request)
         let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billAdd(encryptedString: encryptedString) { result in
             switch result {
             case .success(let response):
                 if let data = self.container.createDecryptionManger().decrypt(with: response) {
                     self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: [BillAddEntity.BillAddResponse]) in
                         self.presenter?.setupBillAdd(response: dataResult)
                         print("Data is \(data)")
                     }
                 }
             case .failure(let error):
                 self.presenter?.showServerErrorMessage(error: error.localizedDescription)
             }
         }
    }
    
}
