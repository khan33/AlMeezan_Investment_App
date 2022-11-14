//
//  RiskProfileRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol RiskProfileRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToPreviewVC(data: SSACNICData)
}

class RiskProfileRouter: RiskProfileRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToPreviewVC(data: SSACNICData) {
        let vc = PreviewBasicInfoVC()
        navigationController?.pushViewController(vc, animated: false)
    }
}
class RiskProfileConfigurator {
    
    static func configureModule(viewController: RiskProfileVC) {
        let router = RiskProfileRouter()
        let interactor = RiskProfileInteractor(worker: BankInfoViewWorker())
        let presetner = RiskProfilePresenter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presetner
        presetner.viewController = viewController
        
        router.navigationController = viewController.navigationController
    }
    
}
