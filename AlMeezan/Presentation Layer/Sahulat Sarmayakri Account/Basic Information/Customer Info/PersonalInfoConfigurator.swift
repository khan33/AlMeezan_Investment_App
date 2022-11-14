//
//  PersonalInfoConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 24/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class PersonalInfoConfigurator {
    
    static func configureModule(viewController: PersonalInfoVC) {
        let router = PersonalInfoRouter()
        let interactor = PersonalInfoInteractor(worker: BasicInfoWorker())
        let preseter = PersonalInfoPresenter()
        viewController.router = router
        viewController.interactor = interactor
        preseter.viewConteroller = viewController
        router.navigationController = viewController.navigationController
    }
    
}
