//
//  BankInfoViewRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
protocol BankInfoViewRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToKYCInfoVC(info: PersonalInfoEntity.BasicInfo)
}

class BankInfoViewRouter: BankInfoViewRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToKYCInfoVC(info: PersonalInfoEntity.BasicInfo) {
        let vc = PrincipalAccountVC(basicInfo: info)
        PrincipalAccountConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
class BankInfoViewConfigurator {
    
    static func configureModule(viewController: BankInfoViewController) {
        let router = BankInfoViewRouter()
        let interactor = BankInfoViewInteractor(worker: BankInfoViewWorker())
        let presenter = BankInfoViewPresenter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
    
}
