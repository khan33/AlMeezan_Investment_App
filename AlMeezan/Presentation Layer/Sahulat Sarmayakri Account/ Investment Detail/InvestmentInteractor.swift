//
//  InvestmentInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 10/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//
import UIKit

class InvestmentInteractor: InvestmentInteractorProtocol {
    var presenter: InvestmentPresenterProtocol?
    let container = DependencyContainer()
    let worker: InvestmentWorkerProtocol
    required init(worker: InvestmentWorkerProtocol) {
        self.worker = worker
    }
    
    func submitFund(request: FundRequest) {
        let jsonString = container.createCodeableManger().encodeToString(from: request)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.submitFundInvestment(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [SubmissionResponse] ) in
                        print("response for fund api = ", result)
                        self.presenter?.submitInvestmentResponse(response: result)
                    }
                } else {
                    self.presenter?.failureRequest()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func getFunds() {
        let requestData = InvestmentFundRequest(isOnline: "S")
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.getFunds(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [AccountOpeningFunds] ) in
                        print("response for fund api = ", result)
                        self.presenter?.getlistOfFund(response: result)
                    }
                } else {
                    self.presenter?.failureRequest()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//{
//    "KeyValue": "CustomerID':ibex,AccessToken':_!b3xGl0b@L,CNIC':4210196316433,FundID':800102-100,AgentID':100119,Amount':5000,Bank':ABL"
//}

