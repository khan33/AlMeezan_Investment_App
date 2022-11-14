//
//  OTPViewControllerRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
class OTPViewControllerRouter: OTPViewControllerRouterProtocol {
    weak var navigationController: UINavigationController?
}

extension OTPViewControllerRouter {
    func nextOTPView(data: CustomerInfo) {
        let vc = OTPVerificationVC(info: data)
        OTPVerificationConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
