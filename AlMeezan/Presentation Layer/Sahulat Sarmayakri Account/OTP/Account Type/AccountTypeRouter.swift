//
//  AccountTypeRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 16/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

protocol AccountTypeRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func nextToPersonalInfoVC()
}

class AccountTypeRouter: AccountTypeRouterProtocol {
    weak var navigationController: UINavigationController?
    
    func nextToPersonalInfoVC() {
        let vc = PersonalInfoVC()
        PersonalInfoConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: true)
    }
}
