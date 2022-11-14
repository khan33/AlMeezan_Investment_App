//
//  InvestmentPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 10/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class InvestmentPresenter: InvestmentPresenterProtocol {
    weak var viewController: InvestmentViewProtocol?
    
    func getlistOfFund(response: [AccountOpeningFunds]) {
        viewController?.fundList(response: response)
    }
    func failureRequest() {
        viewController?.noFund()
    }
    func submitInvestmentResponse(response: [SubmissionResponse]) {
        viewController?.InvestmentResponse(response: response)
    }
}
