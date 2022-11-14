//
//  NavConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class NavConfigurator {
    
    static func configureModule(viewController: NAVViewController) {
        let interactor = NavInteractor(worker: NavWorker())
        let presenter = NavPresenter()
        let router = NavRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
}
