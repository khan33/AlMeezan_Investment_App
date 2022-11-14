//
//  BillTransferConfigurator.swift
//  AlMeezan
//
//  Created by Ahmad on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillTransferConfigurator {
    
    static func configureModule(viewController: BillTransferViewController) {
        let interactor = BillTransferInteractor(worker: BillTransferWorker())
        let presenter =  BillTransferPresenter(error: ErrorMessageHelper())
        let router =  BillTransferRouter()
  
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        presenter.viewConroller = viewController
        
        router.navigationController = viewController.navigationController
    }
}
