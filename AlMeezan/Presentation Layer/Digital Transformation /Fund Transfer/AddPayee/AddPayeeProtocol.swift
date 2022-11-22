//
//  AddPayeeProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 22/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation



// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol AddPayeeInteractorProtocol: AnyObject {
    func viewDidLoad()
    func addPayee(_ data: addPayeeRequestData)
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol AddPayeeViewProtocol: MainViewProtocol {
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel])
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol AddPayeePresenterProtocol: AnyObject {
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel])
}


// MARK: - ROUTER INPUT

protocol AddPayeeRouterProtocol: MainRouterProtocol {
    func navigateToOTPScreen(_ payee: FundTransferEntity.FetchPayeeTitleResponseModel, _ id: String, request: FundTransferEntity.AddPayeeRequest?)
}
