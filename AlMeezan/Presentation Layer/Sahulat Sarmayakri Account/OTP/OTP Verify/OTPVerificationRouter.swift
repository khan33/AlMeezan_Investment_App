//
//  OTPVerificationRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

protocol OTPVerificationRouterProtocol: MainRouterProtocol {
    func nextToAccountTypeVC()
}


class OTPVerificationRouter: OTPVerificationRouterProtocol {
    //MARK: Properties
    weak var navigationController: UINavigationController?
    
    func nextToAccountTypeVC() {
        let vc = AccountTypeVC()
        AccountTypeConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
