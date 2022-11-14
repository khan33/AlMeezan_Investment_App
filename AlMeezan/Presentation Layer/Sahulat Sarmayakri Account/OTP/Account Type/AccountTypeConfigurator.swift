//
//  AccountTypeConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 16/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class AccountTypeConfigurator {
    
    static func configureModule(viewController: AccountTypeVC) {
        let router = AccountTypeRouter()
        viewController.router = router
        router.navigationController = viewController.navigationController
    }
    
    
}
