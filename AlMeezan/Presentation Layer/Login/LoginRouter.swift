//
//  LoginRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class LoginRouter: LoginRouterProtocol {
    weak var navigationController: UINavigationController?
    func routeToDashboard() {
        let vc = DashboardViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        DashboardConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
