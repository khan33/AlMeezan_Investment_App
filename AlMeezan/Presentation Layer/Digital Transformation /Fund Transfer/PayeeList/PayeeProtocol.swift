//
//  PayeeProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol PayeeInteractorProtocol: AnyObject {
    func viewDidLoad()
    func fetchPayeeTitle(_ request: fetchTitleRequest)
    func addPayee(_ data: addPayeeRequestData)
    func bankList()
    func fundTransfer(_ data: fundTransferData)
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol PayeeViewProtocol: MainViewProtocol {
    func successfullResponse(_ response: payeeListResponse)
    func getHistoryResponse(_ response: [[FundTransferEntity.PayeeHistroyModel]])
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol PayeePresenterProtocol: AnyObject {
    func getPayeeList(_ response: payeeListResponse)
    func getPayeeHistoryList(_ response: payeeHistoryResponse)
}


// MARK: - ROUTER INPUT

protocol PayeeRouterProtocol: MainRouterProtocol {
    func addPayee()
    func paymentVC(_ payee: FundTransferEntity.PayeeResponseModel?, portfolio: CustomerInvestment?)
    func billTransfer(_ billing: BillListEntity.BillListResponse?, portfolio: CustomerInvestment?)

}

// MARK: - WORKER

protocol FundTransferWorkerProtocol: AnyObject {
    func getBankList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func fetchPayeeTitle(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func fetchPayeeHistory(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func addPayee(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func payeeList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func fundTransfer(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func OTPVerification(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
