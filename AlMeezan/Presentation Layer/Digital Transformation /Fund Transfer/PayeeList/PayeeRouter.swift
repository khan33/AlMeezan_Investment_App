//
//  PayeeRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 29/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PayeeRouter: PayeeRouterProtocol {
    weak var navigationController: UINavigationController?
    func addPayee() {
        let vc = FetchTitlePayeeVC()
        FetchPayeeVCConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func paymentVC(_ payee: FundTransferEntity.PayeeResponseModel?, portfolio: CustomerInvestment?)  {
        let vc = PaymentViewController(payee: payee, portfolio: portfolio)
        PaymentViewControllerConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func billTransfer(_ billing: BillListEntity.BillListResponse?, portfolio: CustomerInvestment?) {
        let vc = BillTransferViewController(bill: billing, portfolio: portfolio)
        BillTransferConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



class PayeeViewControllerConfigurator {
    
    static func configureModule(viewController: PayeeViewController) {
        let interactor = PayeeInteractor(worker: FundTransferWorker())
        let router =  PayeeRouter()
        let presenter = PayeePresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController

        router.navigationController = viewController.navigationController
    }
    
    
}
 
