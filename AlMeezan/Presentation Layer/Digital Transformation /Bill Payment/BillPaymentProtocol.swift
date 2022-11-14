//
//  BillPaymentProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol BillPaymentInteractorProtocol: AnyObject {
    func viewDidLoad()
    func addBill(_ request: addbill)
    func billPaymentRequest(_ data: billPyament)
    func billInquiryRequest(_ data: billInquiry)
    func billMerchantRequest()
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol BillPaymentViewProtocol: MainViewProtocol {
    
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol BillPaymentPresenterProtocol: AnyObject {
    
}


// MARK: - ROUTER INPUT

protocol BillPaymentRouterProtocol: MainRouterProtocol {
    
}

// MARK: - WORKER

protocol BillPaymentWorkerProtocol: AnyObject {
    func billListRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func billInquiryRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func billPaymentRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func billMerchantRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func addBillRequest(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
