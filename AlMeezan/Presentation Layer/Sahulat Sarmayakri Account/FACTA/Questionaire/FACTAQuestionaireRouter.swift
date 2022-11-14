//
//  FACTAQuestionaireRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

protocol FACTAQuestionaireRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToNextVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?, factaInfo: FACTAModel?)
}

class FACTAQuestionaireRouter: FACTAQuestionaireRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToNextVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?, factaInfo: FACTAModel?) {
        let vc = CRSFormVC(factaInfo: factaInfo, KYCInfo: KYCinfo, basicInfo: basicinfo)
        CRSFormConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
class FACTAQuestionaireConfigurator {
    
    static func configureModule(viewController: FACTAQuestionaireVC) {
        let router = FACTAQuestionaireRouter()
        let interactor = FactaInteractor(worker: BankInfoViewWorker())
        let presetner = FactaPresenter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presetner
        presetner.viewController = viewController
        
        router.navigationController = viewController.navigationController
    }
    
}
