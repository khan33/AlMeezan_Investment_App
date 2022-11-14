//
//  OTPVerificationConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class OTPVerificationConfigurator {
    
    static func configureModule(viewController: OTPVerificationVC) {
        let interactor = OTPVerificationInteractor(worker: OTPVerificationWorker())
        let presenter =  OTPVerificationPresenter(error: ErrorMessageHelper())
        let router =  OTPVerificationRouter()
  
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        
        router.navigationController = viewController.navigationController
    }
    
    
}
