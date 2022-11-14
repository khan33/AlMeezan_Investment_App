//
//  FATCAFormRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

protocol FATCAFormRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToQuestionairVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?, factaInfo: FACTAModel?)
}

class FATCAFormRouter: FATCAFormRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToQuestionairVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?, factaInfo: FACTAModel?) {
        let vc = FACTAQuestionaireVC(factaInfo: factaInfo, KYCInfo: KYCinfo, basicInfo: basicinfo)
        FACTAQuestionaireConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
class FATCAFormConfigurator {
    
    static func configureModule(viewController: FATCAFormVC) {
        let router = FATCAFormRouter()
        viewController.router = router
        router.navigationController = viewController.navigationController
    }
    
}

