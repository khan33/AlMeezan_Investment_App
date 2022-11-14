//
//  ForexConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class ForexConfigurator {
    
    static func configureModule(viewController: ForexViewController) {
        let interactor = ForexInteractor(worker: ForexWorker())
        let presenter = ForexPresenter()
        let router = ForexRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        router.navigationController = viewController.navigationController
    }
    
    
}
