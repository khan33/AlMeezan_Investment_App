//
//  ContactInfoRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 26/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
protocol ContactInfoRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToBankInfoVC(info: PersonalInfoEntity.BasicInfo)
}

class ContactInfoRouter: ContactInfoRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToBankInfoVC(info: PersonalInfoEntity.BasicInfo) {
        let vc = BankInfoViewController(basicInfo: info)
        BankInfoViewConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
