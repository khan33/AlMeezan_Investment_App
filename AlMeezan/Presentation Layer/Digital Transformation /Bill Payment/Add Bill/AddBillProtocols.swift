//
//  AddBillProtocols.swift
//  AlMeezan
//
//  Created by Ahmad on 30/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

protocol AddBillInteractorProtocol: AnyObject {
    func loadAddMerchandBill()
    func loadBillInquiry(request: BillInquiryEntity.BillInquiryRequest)
    func saveBillAdd(request: BillAddEntity.BillAddRequest)
}
// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol AddBillViewProtocol: AnyObject {
    func successBillList(response: [AddBillEntity.AddBillResponse])
    func successBillInquiry(response: [BillInquiryEntity.BillInquiryResponse])
    func successBillAdd(response: [BillAddEntity.BillAddResponse])
    func showDataFailure(error: String)
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol AddBillPresenterProtocol: MainPresenterProtocol {
    func setupAddBillMerchantList(response: [AddBillEntity.AddBillResponse])
    func setupBillInquiry(response: [BillInquiryEntity.BillInquiryResponse])
    func setupBillAdd(response: [BillAddEntity.BillAddResponse])
}

// MARK: - ROUTER INPUT

protocol AddBillRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func nextToOTP()
}

// MARK: - WORKER

protocol AddBillWorkerProtocol: AnyObject {
    func addBillMerchantList(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func billInquiry(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func billAdd(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
