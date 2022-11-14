//
//  LoginConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class LoginConfigurator {
    
    static func configureModule(viewController: LoginViewController) {
        let interactor = LoginInteractor(worker: LoginWorker())
        let presenter = LoginPresenter()
        let router = LoginRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        router.navigationController = viewController.navigationController
    }
    
    
}
