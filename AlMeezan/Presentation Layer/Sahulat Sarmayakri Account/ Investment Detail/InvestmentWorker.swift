//
//  InvestmentWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 10/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class InvestmentWorker: InvestmentWorkerProtocol {
    func getFunds(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: InvestmentFundRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
    
    func submitFundInvestment(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: InvestmentFundSubmitRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
}
