//
//  PaymentServiceRouter.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 31/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PaymentServiceRouter: SubscriptionRouterProtocol {
    weak var navigationController: UINavigationController?
}



class PaymentServiceConfigurator {
    
    static func configureModule(viewController: PaymentServicesVC) {
        let interactor = PaymentServiceInteractor(worker: SubscriptionWorker())
        let router =  PaymentServiceRouter()
        let presenter = PaymentServicePresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController

        router.navigationController = viewController.navigationController
    }
}
