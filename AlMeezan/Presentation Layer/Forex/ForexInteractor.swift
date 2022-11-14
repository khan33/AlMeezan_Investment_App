//
//  ForexInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
protocol ForexInteractorProtocol: class {
    func fetchForexList()
}


class ForexInteractor: ForexInteractorProtocol {
    var presenter: ForexPresenterProtocol?

    let worker: ForexWorkerProtocol
    let container = DependencyContainer()
    required init(worker: ForexWorkerProtocol ) {
        self.worker    = worker
    }
    
    func fetchForexList() {
        // get request data
        let requestData = ForexEntity.ForexRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.fetch(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                print(resposne)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
