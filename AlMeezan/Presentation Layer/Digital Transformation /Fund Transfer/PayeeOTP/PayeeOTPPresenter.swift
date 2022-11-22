//
//  PayeeOTPPresetner.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 04/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PayeeOTPPresetner : PayeeOTPPresenterProtocol {
    
    
    
    weak var viewController: PayeeOTPViewProtocol?
    func otpVerificationResponse(_ response: otpVerifcationResponse) {
        viewController?.otpVerificationSuccess(response)
    }
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel]) {
        viewController?.addPayee(response)
    }
    
    func setupBillInquiry(response: [BillInquiryEntity.BillInquiryResponse]) {
        viewController?.successBillInquiry(response: response)
    }
    
    

}
