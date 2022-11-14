//
//  BillTransferProtocols.swift
//  AlMeezan
//
//  Created by Ahmad on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

protocol BillTransferInteractorProtocol: AnyObject {
    func saveBillPayment(request: BillTransferEntity.BillTransferRequest)
}
// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol BillTransferViewProtocol: AnyObject {
    func successBillPayment(response: [BillTransferEntity.BillTransferResponse])
    func showDataFailure(error: String)
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol BillTransferPresenterProtocol: MainPresenterProtocol {
    func setupBillPayment(response: [BillTransferEntity.BillTransferResponse])
}

// MARK: - ROUTER INPUT

protocol BillTransferRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func nextToVerifyPayment()
    func successScreen()
}

// MARK: - WORKER

protocol BillTransferWorkerProtocol: AnyObject {
    func billPayment(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
