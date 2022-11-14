//
//  SubscriptionRouter.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 07/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class SubscriptionRouter: SubscriptionRouterProtocol {
    weak var navigationController: UINavigationController?
}



class SubscriptionConfigurator {
    
    static func configureModule(viewController: SubscriptionViewController) {
        let interactor = SubscriptionInteractor(worker: SubscriptionWorker())
        let router =  SubscriptionRouter()
        let presenter = SubscriptionPresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController

        router.navigationController = viewController.navigationController
    }
    
    
}
