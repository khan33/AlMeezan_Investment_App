//
//  BillPaymentInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class BillPaymentInteractor: BillPaymentInteractorProtocol {
    
    let container = DependencyContainer()
    let worker: BillPaymentWorkerProtocol
    required init(worker: BillPaymentWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        billingList()
    }

    private func billingList() {
        let requestData = BillPaymentEntity.BillingRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billListRequest(encryptedString: encryptedString) { result in
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
    func addBill(_ request: addbill) {
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.addBillRequest(encryptedString: encryptedString) { result in
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
    func billPaymentRequest(_ data: billPyament) {
        let jsonString = container.createCodeableManger().encodeToString(from: data)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billPaymentRequest(encryptedString: encryptedString) { result in
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
    
    
    
    
    func billMerchantRequest() {
        let requestData = BillPaymentEntity.BillMerchantListRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billMerchantRequest(encryptedString: encryptedString) { result in
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
    
    func billInquiryRequest(_ data: billInquiry) {
        let jsonString = container.createCodeableManger().encodeToString(from: data)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.billInquiryRequest(encryptedString: encryptedString) { result in
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
