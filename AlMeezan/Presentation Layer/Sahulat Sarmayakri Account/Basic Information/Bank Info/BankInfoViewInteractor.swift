//
//  BankInfoViewInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 12/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
class BankInfoViewInteractor: BankInofoViewInteractorProtocol {
    var presenter: BankInforPresenterProtocol?
    let container = DependencyContainer()
    let worker: BankInfoWorkerProtocol
    required init(worker: BankInfoWorkerProtocol) {
        self.worker = worker
    }
    
    func getBranchName() {
        let requestData = BankInfoViewEntity.BankInfoRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.getBranchCity(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (dataResult: [BranchLocator] ) in
                        print(dataResult)
                        self.presenter?.getBranch(response: dataResult)
                    }
                }
            case .failure(let error):
                self.presenter?.failedRequest()
            }
        }
    }
    
    func getBankName() {
        let requestData = BankInfoViewEntity.BankInfoRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.getBankInfo(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (dataResult: [BankInfoViewEntity.BankInfoResponseModel] ) in
                        self.presenter?.successData(response: dataResult)
                    }
                }
            case .failure(let error):
                self.presenter?.failedRequest()
            }
        }
    }
    
    func saveData(basicInfo: PersonalInfoEntity.BasicInfo?, healthDec: HealthDec?, kyc: KYCModel?, fatca: FACTAModel?, crs: Crs?, riskProfile: RiskProfile?) {
        let requestData = SSACNICData(basicInfo: basicInfo, healthDec: healthDec, kyc: kyc, fatca: fatca, crs: crs, riskProfile: riskProfile)
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.submitApi(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (dataResult: [SubmissionResponse] ) in
                        self.presenter?.SaveDatasuccessfully(response: dataResult)
                    }
                }
            case .failure(let error):
                self.presenter?.failedRequest()
            }
        }
        
        
    }
    
}
