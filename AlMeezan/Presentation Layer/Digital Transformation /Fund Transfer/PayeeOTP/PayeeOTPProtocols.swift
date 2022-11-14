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
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol PayeeOTPViewProtocol: MainViewProtocol {
    func otpVerificationSuccess(_ response: otpVerifcationResponse)
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol PayeeOTPPresenterProtocol: AnyObject {
    func otpVerificationResponse(_ response: otpVerifcationResponse)
}


// MARK: - ROUTER INPUT

protocol PayeeOTPRouterProtocol: MainRouterProtocol {
    
}
