//
//  ContactInfoConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class ContactInfoConfigurator {
    
    static func configureModule(viewController: ContactInfoViewController) {
        let router = ContactInfoRouter()
        let interactor = ContactInfoInteractor(worker: BankInfoViewWorker())
        let presetner = ContactInfoPresetner()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presetner
        presetner.viewcontroller = viewController
        router.navigationController = viewController.navigationController
    }
    
}
