//
//  AddBillConfigurator.swift
//  AlMeezan
//
//  Created by Ahmad on 30/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class AddBillConfigurator {
    
    static func configureModule(viewController: AddBillController) {
        let interactor = AddBillInteractor(worker: AddBillWorker())
        let presenter =  AddbillPresenter(error: ErrorMessageHelper())
        let router =  AddBillRouter()
  
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        
        router.navigationController = viewController.navigationController
    }
}
