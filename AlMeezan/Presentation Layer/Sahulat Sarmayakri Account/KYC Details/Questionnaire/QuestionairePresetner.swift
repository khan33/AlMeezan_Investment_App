//
//  QuestionairePresetner.swift
//  AlMeezan
//
//  Created by Atta khan on 25/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

protocol QuestionairePresenterProtocol: ErrorMessageProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func failedRequest()
}

protocol QuestionaireViewProtocol: MainViewProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse])
}


class QuestionairePresetner: QuestionairePresenterProtocol {
    
    weak var viewController: QuestionaireViewProtocol?
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response.count > 0 {
            viewController?.SaveDatasuccessfully(response: response)
        }
    }
    func failedRequest() {
        
    }
}
