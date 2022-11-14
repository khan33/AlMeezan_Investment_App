//
//  NavWorker.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation



class NavWorker: NavWorkerProtocol {
    func getNavFundslist(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void) {
        ServiceManager.shared.sendRequest(request: NavEntity.NavRequestModel(KeyValue: encryptedString)) { response in
            completion(response)
        }
    }
}
