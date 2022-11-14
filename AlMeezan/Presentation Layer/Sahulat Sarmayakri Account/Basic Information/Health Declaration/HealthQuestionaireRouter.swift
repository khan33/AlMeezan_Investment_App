//
//  HealthQuestionaireRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 06/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class HealthQuestionaireRouter: HealthQuestionaireRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToContactInfoVC() {
//        let vc = PrincipalAccountVC()
//        PrincipalAccountConfigurator.configureModule(viewController: vc)
//        navigationController?.pushViewController(vc, animated: false)
    }
}
class HealthQuestionaireConfigurator {
    static func configureModule(viewController: HealthQuestionaireVC) {
        let router = HealthQuestionaireRouter()
        let interactor = BasicInfoInteractor(worker: BasicInfoWorker())
        let presenter = BasicInfoPresenter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
    
}
