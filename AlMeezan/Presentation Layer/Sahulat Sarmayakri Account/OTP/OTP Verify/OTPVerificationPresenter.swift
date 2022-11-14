//
//  OTPVerificationPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 03/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
class OTPVerificationPresenter: OTPVerificationPresenterProtocol {
    var numberofRow: Int = 0
    
    //MARK: Properties
    weak var viewConroller: OTPVerificationViewProtocol?
    let errorHelper : ErrorMessageHelper
    init(error: ErrorMessageHelper) {
        self.errorHelper = error
    }
    
    func OTPVerifcationData(response: OTPVerificationEntity.OTPVerificationResponseModel) {
        if let otpVerify = response.oTPVerification, otpVerify.count > 0 {
            if let errId = otpVerify[0].errID, errId == "00" {
                Constant.CustomerData.customer_data = response
                if let sourceOfIncome = response.cNICData?.kyc?.sourceOfIncome {
                    UserDefaults.standard.set(sourceOfIncome, forKey: "SourceOfIncome")
                }
                Constant.SSA_data = response.cNICData
                Constant.health_dec = response.cNICData?.healthDec
                viewConroller?.OTPVerifcationSuccessData(response: response)
            } else {
                let message = errorHelper.returnErrorMessage(id: otpVerify[0].errID ?? "" )
                viewConroller?.isErrorMessage(withMessage: message)
            }
        }
    }
    func OTPFailedData() {
        viewConroller?.OTPEmptyField()
    }
    
    func OTPResendSuccessfully(response: [OTPViewControllerEntity.OTPResponseModel]) {
        if response.count > 0 {
            if let errId = response[0].errID, errId == "00" {
                viewConroller?.successfullyOTPSend()
            } else {
                viewConroller?.OTPEmptyField()
                let message = errorHelper.returnErrorMessage(id: response[0].errID ?? "")
                viewConroller?.isErrorMessage(withMessage: message)
            }
        }
    }
}
