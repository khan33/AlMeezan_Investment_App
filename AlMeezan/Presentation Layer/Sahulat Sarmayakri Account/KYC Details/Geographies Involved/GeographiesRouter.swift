//
//  GeographiesRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
protocol GeographiesRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToQuestionaireVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?)
}

class GeographiesRouter: GeographiesRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToQuestionaireVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?) {
        let vc = QuestionnaireVC(KYCInfo: KYCinfo, basicInfo: basicinfo)
        QuestionnaireConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
class GeographiesConfigurator {
    
    static func configureModule(viewController: GeographiesVC) {
        let router = GeographiesRouter()
        viewController.router = router
        router.navigationController = viewController.navigationController
    }
    
}
