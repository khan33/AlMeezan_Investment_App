//
//  FactaPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 25/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol FactaPresenterProtocol: ErrorMessageProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func failedRequest()
}

protocol FactaViewProtocol: MainViewProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse])
}


class FactaPresenter: FactaPresenterProtocol {
    weak var viewController: FactaViewProtocol?
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response.count > 0 {
            viewController?.SaveDatasuccessfully(response: response)
        }
    }
    func failedRequest() {
        
    }
}
