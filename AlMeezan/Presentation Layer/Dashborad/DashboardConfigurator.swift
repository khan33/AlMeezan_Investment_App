//
//  DashboardConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
class DashboardConfigurator {
    
    static func configureModule(viewController: DashboardViewController) {
        let interactor = DashboardInteractor()
        let presenter = DashboardPresenter()
        let router = DashboardRouter()
        
//        viewController.interactor = interactor
//        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        router.navigationController = viewController.navigationController
    }
}
