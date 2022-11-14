//
//  OTPViewControllerPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class OTPViewControllerPresenter: OTPViewControllerPresenterProtocol {
    weak var viewConroller: OTPViewControllerViewProtocol?
    let errorHelper : ErrorMessageHelper
    init(error: ErrorMessageHelper) {
        self.errorHelper = error
    }
    
    
    func setupDataSuccess(data: SetupModel?) {
        viewConroller?.setupDataSuccess(data: data)
    }
    
    func dataFailure(error: String) {
        viewConroller?.hasServerError(message: error)
    }
    
    
    
    func sendOTPSuccessfully(response: [OTPViewControllerEntity.OTPResponseModel]) {
        if response.count > 0 {
            if let errId = response[0].errID, errId == "00" {
                viewConroller?.successfullyOTPSend()
//                if let pin = response[0].sMSPin {
//                    UserDefaults.standard.set(pin, forKey: "PinCode")
//                    viewConroller?.successfullyOTPSend()
//                }
            } else {
                viewConroller?.setupDataFailure()
                let message = errorHelper.returnErrorMessage(id: response[0].errID ?? "")
                viewConroller?.isErrorMessage(withMessage: message)
            }
        }
    }
    
}
