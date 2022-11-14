//
//  InvestmentRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 10/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol InvestmentRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
}

class InvestmentRouter: InvestmentRouterProtocol {
    weak var navigationController: UINavigationController?
    
}
class InvestmentConfigurator {
    
    static func configureModule(viewController: InvestmentdetailsViewController) {
        let router = InvestmentRouter()
        let interactor = InvestmentInteractor(worker: InvestmentWorker())
        let presenter = InvestmentPresenter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
    
}
