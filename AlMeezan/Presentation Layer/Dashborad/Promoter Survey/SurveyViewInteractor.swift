//
//  SurveyViewInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 18/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol SurveyViewInteractorProtocol: AnyObject {
    func surveySubmission(_ request: SurveyRequestModel)
    func cancelSurvey(_ request: SurveyCancelModel)
}
protocol SurveyViewWorkerProtocol: AnyObject {
    func submissionSurvey(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func cancelsurvey(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}


class SurveyViewInteractor: SurveyViewInteractorProtocol {
    
    var presenter: SurveyViewPresetnerProtocol?
    let worker: SurveyViewWorkerProtocol
    let container: DependencyContainer
    required init(worker: SurveyViewWorkerProtocol, container: DependencyContainer ) {
        self.worker = worker
        self.container = container
    }
    
    func surveySubmission(_ request: SurveyRequestModel) {
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.submissionSurvey(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [SurveyResponseModel] ) in
                        self.presenter?.response(with: result)
                    }
                } else {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelSurvey(_ request: SurveyCancelModel) {
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.cancelsurvey(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [SurveyResponseModel] ) in
                        self.presenter?.response(with: result)
                    }
                } else {
                    
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}




class SurveyViewWorker: SurveyViewWorkerProtocol {
    func cancelsurvey(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SurveyCancelRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func submissionSurvey(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: SurveySubmissionRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    

}
