//
//  QuestionnaireRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
protocol QuestionnaireRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToFACTAVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?)
}

class QuestionnaireRouter: QuestionnaireRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToFACTAVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?) {
        let vc = FATCAFormVC(KYCInfo: KYCinfo, basicInfo: basicinfo)
        FATCAFormConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
class QuestionnaireConfigurator {
    static func configureModule(viewController: QuestionnaireVC) {
        let router = QuestionnaireRouter()
        let interactor = QuestionaireInteractor(worker: BankInfoViewWorker())
        let presetner = QuestionairePresetner()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presetner
        presetner.viewController = viewController
        router.navigationController = viewController.navigationController
    }
    
}

