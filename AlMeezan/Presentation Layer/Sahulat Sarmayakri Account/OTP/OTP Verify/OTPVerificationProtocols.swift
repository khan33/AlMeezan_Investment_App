//
//  OTPVerificationProtocols.swift
//  AlMeezan
//
//  Created by Atta khan on 03/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

// MARK: - VIEW INPUT ( VIEW -> INTERACTOR
protocol OTPVerificationInteractorProtocol: AnyObject {
    func verifyPinCode(code: String?)
    func resendOTP(info: CustomerInfo)
}

// MARK: - VIEW OUPUT (PRESENTER -> VIEW)
protocol OTPVerificationViewProtocol: MainViewProtocol {
    func OTPVerifcationSuccessData(response: OTPVerificationEntity.OTPVerificationResponseModel)
    func OTPEmptyField()
    func successfullyOTPSend()
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol OTPVerificationPresenterProtocol: AnyObject {
    func OTPVerifcationData(response: OTPVerificationEntity.OTPVerificationResponseModel)
    func OTPFailedData()
    var numberofRow: Int { get }
    func OTPResendSuccessfully(response: [OTPViewControllerEntity.OTPResponseModel])
    
}


// MARK: - WORKER

protocol OTPVerificationWorkerProtocol: AnyObject {
    func VerifyOTP(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func generateOTP(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}

