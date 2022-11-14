//
//  ForexWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
protocol ForexWorkerProtocol: AnyObject {
    func fetch(encryptedString: String, completion: @escaping (Swift.Result<String, Error>) -> Void)
}

class ForexWorker: ForexWorkerProtocol {
    func fetch(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        ServiceManager.shared.sendRequest(request: ForexEntity.ForexRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
        
    }
    
}
