//
//  SurveyViewRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 19/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

protocol SurveyViewRouterProtocol {
    
    
}




class SurveyViewRouter: SurveyViewRouterProtocol {
    weak var navigationController: UINavigationController?
}



class SurveyViewConfigurator {
    static func configureModule(viewController: SurveyViewController) {
        let router = SurveyViewRouter()
        let interactor = SurveyViewInteractor(worker: SurveyViewWorker(), container: DependencyContainer())
        let presenter = SurveyViewPresenter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
    
}
