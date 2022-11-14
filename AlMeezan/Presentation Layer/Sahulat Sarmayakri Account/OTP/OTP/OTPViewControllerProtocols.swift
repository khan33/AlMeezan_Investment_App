//
//  OTPGeneratorProtocols.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol OTPViewControllerInteractorProtocol: AnyObject {
    func viewDidLoad()
    func didTapOnContinueBtn(cnic: String?, phone: String?, email: String?, simOwnerTxt: String?, simOwnerCode: String?)
    func saveCustomer(data: CustomerInfo)
    func retriveCustomer() -> CustomerInfo?
    func loadData()
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol OTPViewControllerViewProtocol: MainViewProtocol {
    func setupDataSuccess(data: SetupModel?)
    func setupDataFailure()
    func successfullyOTPSend()
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol OTPViewControllerPresenterProtocol: AnyObject {
    func setupDataSuccess(data: SetupModel?)
    func dataFailure(error: String)
    func sendOTPSuccessfully(response: [OTPViewControllerEntity.OTPResponseModel])
}


// MARK: - ROUTER INPUT

protocol OTPViewControllerRouterProtocol: MainRouterProtocol {
    func nextOTPView(data: CustomerInfo)
}

// MARK: - WORKER

protocol OTPViewControllerWorkerProtocol: AnyObject {
    func generateOTP(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func verifyOTP()
    func setUpData(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
