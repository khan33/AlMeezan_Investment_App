//
//  Configurator.swift
//  AlMeezan
//
//  Created by Ahmad on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillListConfigurator {
    
    static func configureModule(viewController: BillListController) {
        let interactor = BillListInteractor(worker: BillListWorker())
        let presenter =  BillListPresenter(error: ErrorMessageHelper())
        let router =  BillListRouter()
  
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        
        router.navigationController = viewController.navigationController
    }
}
