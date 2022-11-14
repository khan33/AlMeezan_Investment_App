//
//  PersonalInfoRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 24/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation



class PersonalInfoRouter: PersonalInfoRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToContactInfoVC(info: PersonalInfoEntity.BasicInfo) {
        let vc = ContactInfoViewController(basicInfo: info)
        ContactInfoConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func routerToHealthDec(info: PersonalInfoEntity.BasicInfo) {
        
    }
    
    
}
