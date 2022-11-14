//
//  RiskProfileInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 25/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol RiskProfileInteractorProtocol: AnyObject {
    
    func riskCalculation(age: String, ageYear: Int, riskReturn: String, monthlySaving: String, occupaiton: String, investmentObjective: String, knowledgeLevel: String, investmentHorizon: String)
    
    func saveData(basicInfo: PersonalInfoEntity.BasicInfo?, healthDec: HealthDec?, kyc: KYCModel?, fatca: FACTAModel?, crs: Crs?, riskProfile: RiskProfile?)
}


class RiskProfileInteractor: RiskProfileInteractorProtocol {
    var presenter: RiskProfilePresenterProtocol?
    let container = DependencyContainer()
    let worker: BankInfoWorkerProtocol
    required init(worker: BankInfoWorkerProtocol) {
        self.worker = worker
    }
    func riskCalculation(age: String, ageYear: Int, riskReturn: String, monthlySaving: String, occupaiton: String, investmentObjective: String, knowledgeLevel: String, investmentHorizon: String) {
        let requestData = RiskProfileEntity.RiskProfileRequest(ageInYears: ageYear, age: age, riskReturn: riskReturn, monthlySavings: monthlySaving, occupation: occupaiton, investmentObjective: investmentObjective, knowledgeLevel: knowledgeLevel, investmentHorizon: investmentHorizon)
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.calculateRisk(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: RiskProfileEntity.RiskProfileResponseModel) in
                        self.presenter?.getSuccessdata(response: dataResult)
                    }
                }
            case .failure(let error):
                print(error)
                //self.presenter?.failedRequest()
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
                print(error)
                //self.presenter?.failedRequest()
            }
        }
        
        
    }
}
