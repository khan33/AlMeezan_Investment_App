//
//  BasicInfoInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 23/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class BasicInfoInteractor: BasicInfoInteractorProtoocl {
    var presenter: BasicInfoPresenterProtocol?
    let container = DependencyContainer()
    let worker: BasicInfoWorkerProtocol
    required init(worker: BasicInfoWorkerProtocol) {
        self.worker = worker
    }
    
    func saveData(basicInfo: PersonalInfoEntity.BasicInfo?, healthDec: HealthDec?, kyc: KYCModel?, fatca: FACTAModel?, crs: Crs?, riskProfile: RiskProfile?) {
        let requestData = SSACNICData(basicInfo: basicInfo, healthDec: healthDec, kyc: kyc, fatca: fatca, crs: crs, riskProfile: riskProfile)
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.saveData(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (dataResult: [SubmissionResponse] ) in
                        self.presenter?.SaveDatasuccessfully(response: dataResult)
                    }
                }
            case .failure(let error):
                self.presenter?.FailureResponse()
                
            }
        }
    }
    
    
    
    
}


class BasicInfoWorker: BasicInfoWorkerProtocol {
    func saveData(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SubmissionSSARequestModel(KeyValue: encryptedString )) { response in
            completion(response)
        }
    }
}
