//
//  CRSInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 27/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol CRSInteractorProtocol: AnyObject {
    func saveData(basicInfo: PersonalInfoEntity.BasicInfo?, healthDec: HealthDec?, kyc: KYCModel?, fatca: FACTAModel?, crs: Crs?, riskProfile: RiskProfile?)
    func getCountries()
}


class CRSInteractor: CRSInteractorProtocol {
    var presenter: CRSPresenterProtocol?
    let container = DependencyContainer()
    let worker: BankInfoWorkerProtocol
    required init(worker: BankInfoWorkerProtocol) {
        self.worker = worker
    }
    func getCountries() {
        let requestData = CountryRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.getCountry(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: CountryModel ) in
                        self.presenter?.successData(resposne: dataResult)
                    }
                }
            case .failure(let error):
                print(error)
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
