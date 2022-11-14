//
//  CRSPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 27/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol CRSPresenterProtocol: ErrorMessageProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func failedRequest()
    func successData(resposne: CountryModel)
}

protocol CRSViewProtocol: MainViewProtocol {
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func getCountries(resposne: CountryModel)
}


class CRSPresenter: CRSPresenterProtocol {
    weak var viewController: CRSViewProtocol?
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response.count > 0 {
            viewController?.SaveDatasuccessfully(response: response)
        }
    }
    func failedRequest() {
        
    }
    func successData(resposne: CountryModel) {
        viewController?.getCountries(resposne: resposne)
    }
}
