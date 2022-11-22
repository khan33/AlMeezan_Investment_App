//
//  PayeeOTPProtocols.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 04/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR)

protocol PayeeOTPInteractorProtocol: AnyObject {
    func otpVerify(_ data: otpVerificationReqeust)
    func addPayee(_ data: addPayeeRequestData)
    func loadBillInquiry(request: BillInquiryEntity.BillInquiryRequest)

}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol PayeeOTPViewProtocol: MainViewProtocol {
    func otpVerificationSuccess(_ response: otpVerifcationResponse)
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel])
    func successBillInquiry(response: [BillInquiryEntity.BillInquiryResponse])
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol PayeeOTPPresenterProtocol: AnyObject {
    func otpVerificationResponse(_ response: otpVerifcationResponse)
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel])
    func setupBillInquiry(response: [BillInquiryEntity.BillInquiryResponse])
}


// MARK: - ROUTER INPUT

protocol PayeeOTPRouterProtocol: MainRouterProtocol {
    
}
