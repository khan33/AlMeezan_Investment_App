//
//  OTPViewControllerConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


class OTPViewControllerConfigurator {
    
    static func configureModule(viewController: OTPViewController) {
        let interactor = OTPViewControllerInteractor(worker: OTPViewControllerWorker())
        let presenter =  OTPViewControllerPresenter(error: ErrorMessageHelper())
        let router =  OTPViewControllerRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        
        router.navigationController = viewController.navigationController
    }
    
    
}
 
