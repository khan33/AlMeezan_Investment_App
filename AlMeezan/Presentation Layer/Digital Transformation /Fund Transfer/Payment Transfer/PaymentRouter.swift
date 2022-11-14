//
//  PaymentRouter.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PaymentRouter: PaymentRouterProtocol {
    weak var navigationController: UINavigationController?
    
}



class PaymentViewControllerConfigurator {
    
    static func configureModule(viewController: PaymentViewController) {
        let interactor = PaymentInteractor(worker: FundTransferWorker())
        let router =  PaymentRouter()
        let presenter = PaymentPresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
    
    
}
