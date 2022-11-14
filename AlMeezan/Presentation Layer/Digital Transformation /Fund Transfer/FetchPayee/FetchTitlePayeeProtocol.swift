//
//  AddPayeeValiateProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 29/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol FetchTitlePayeeInteractorProtocol: AnyObject {
    func viewDidLoad()
    func fetchTitlePayee(_ data: fetchTitleRequest)
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol FetchTitlePayeeViewProtocol: MainViewProtocol {
    func getlistOfBank(_ response: [BankInfoViewEntity.BankInfoResponseModel]?)
    func fetchTitleResponse(_ response: fetchTitleResponse)

}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol FetchTitlePayeePresenterProtocol: AnyObject {
    func bankList(_ response: [BankInfoViewEntity.BankInfoResponseModel]?)
    func fetchTitleResponse(_ response: fetchTitleResponse)
}


// MARK: - ROUTER INPUT

protocol FetchTitlePayeeRouterProtocol: MainRouterProtocol {
    func addPayee(_ payee: FundTransferEntity.FetchPayeeTitleResponseModel)
}
