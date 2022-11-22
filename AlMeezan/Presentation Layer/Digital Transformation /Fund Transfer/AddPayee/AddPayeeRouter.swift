//
//  AddPayeeRouter.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 04/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class AddPayeeRouter: AddPayeeRouterProtocol {
    weak var navigationController: UINavigationController?
    func navigateToOTPScreen(_ payee: FundTransferEntity.FetchPayeeTitleResponseModel, _ id: String, request: FundTransferEntity.AddPayeeRequest?){
        let vc = AddPayeeOTPViewController(payee: payee, unique_id: id, type: .fundTransfer, transferReq: request, billReq: nil)
        PayeeOTPConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



class AddPayeeConfigurator {
    
    static func configureModule(viewController: AddPayeeVC) {
        let interactor = AddPayeeInteractor(worker: FundTransferWorker())
        let router =  AddPayeeRouter()
        let presenter = AddPayeePresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
}
