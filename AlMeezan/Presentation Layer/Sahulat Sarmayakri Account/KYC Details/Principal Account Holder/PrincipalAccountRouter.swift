//
//  PrincipalAccountRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
protocol PrincipalAccountRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToKYCGeographicVC(basicinfo: PersonalInfoEntity.BasicInfo, KYCinfo: KYCModel)
}

class PrincipalAccountRouter: PrincipalAccountRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToKYCGeographicVC(basicinfo: PersonalInfoEntity.BasicInfo, KYCinfo: KYCModel) {
        let vc = GeographiesVC(KYCInfo: KYCinfo, basicInfo: basicinfo)
        GeographiesConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
class PrincipalAccountConfigurator {
    
    static func configureModule(viewController: PrincipalAccountVC) {
        let router = PrincipalAccountRouter()
        viewController.router = router
        router.navigationController = viewController.navigationController
    }
    
}
