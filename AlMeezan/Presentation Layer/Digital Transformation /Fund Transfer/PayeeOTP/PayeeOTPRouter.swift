//
//  PayeeOTPRouter.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 04/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PayeeOTPRouter: PayeeOTPRouterProtocol {
    weak var navigationController: UINavigationController?

}

class PayeeOTPConfigurator {
    
    static func configureModule(viewController: AddPayeeOTPViewController) {
        let interactor = PayeeOTPInteractor(worker: FundTransferWorker())
        let router =  PayeeOTPRouter()
        let presenter = PayeeOTPPresetner()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
}
