//
//  FetchPayeeRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 29/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class FetchPayeeRouter: FetchTitlePayeeRouterProtocol {
    weak var navigationController: UINavigationController?
    func addPayee(_ payee: FundTransferEntity.FetchPayeeTitleResponseModel) {
        let vc = AddPayeeVC(payee: payee)
        AddPayeeConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



class FetchPayeeVCConfigurator {
    
    static func configureModule(viewController: FetchTitlePayeeVC) {
        let interactor = FetchTitlePayeeInteractor(worker: FundTransferWorker())
        let router =  FetchPayeeRouter()
        let presenter = FetchTitlePayeePresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController

        router.navigationController = viewController.navigationController
    }
    
    
}
