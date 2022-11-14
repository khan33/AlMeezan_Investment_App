//
//  Protocols.swift
//  AlMeezan
//
//  Created by Ahmad on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

protocol BillListInteractorProtocol: AnyObject {
    func loadBillList()
    func loadHistoryList() 
}
// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol BillListViewProtocol: AnyObject {
    func successBillList(response: [BillListEntity.BillListResponse])
    func successHistoryList(response:[[FundTransferEntity.PayeeHistroyModel]] )
    func showDataFailure(error: String)
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol BillListPresenterProtocol: MainPresenterProtocol {
    func setupBillList(response: [BillListEntity.BillListResponse])
    func billHistoryList(response: [FundTransferEntity.PayeeHistroyModel])
}

// MARK: - ROUTER INPUT

protocol BillListRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func nextoToAddBill()
}

// MARK: - WORKER

protocol BillListWorkerPrtocol: AnyObject {
    func setupBillList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func billHistoryList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}

protocol MainPresenterProtocol: AnyObject {
    func showServerErrorMessage(error: String)
}
