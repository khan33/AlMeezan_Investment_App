//
//  InvestmentProtocols.swift
//  AlMeezan
//
//  Created by Atta khan on 10/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR )
protocol InvestmentInteractorProtocol {
    func getFunds()
    func submitFund(request: FundRequest)
}
// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol InvestmentPresenterProtocol {
    func getlistOfFund(response: [AccountOpeningFunds])
    func failureRequest()
    func submitInvestmentResponse(response: [SubmissionResponse])

}

// MARK: - VIEW OUPUT (PRESENTER -> VIEW)
protocol InvestmentViewProtocol: AnyObject {
    func fundList(response: [AccountOpeningFunds])
    func noFund()
    func InvestmentResponse(response: [SubmissionResponse])
}

// MARK: - WORKER

protocol InvestmentWorkerProtocol: AnyObject {
    func getFunds(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func submitFundInvestment(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
