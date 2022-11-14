//
//  CRSFormRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol CRSFormRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func routerToRiskProfileVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?, factaInfo: FACTAModel?, crs: Crs?)
}

class CRSFormRouter: CRSFormRouterProtocol {
    weak var navigationController: UINavigationController?
    func routerToRiskProfileVC(basicinfo: PersonalInfoEntity.BasicInfo?, KYCinfo: KYCModel?, factaInfo: FACTAModel?, crs: Crs?) {
        let vc = RiskProfileVC(factaInfo: factaInfo, KYCInfo: KYCinfo, basicInfo: basicinfo, crs: crs)
        RiskProfileConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
class CRSFormConfigurator {
    static func configureModule(viewController: CRSFormVC) {
        let router = CRSFormRouter()
        let interactor = CRSInteractor(worker: BankInfoViewWorker())
        let presetner = CRSPresenter()
        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presetner
        presetner.viewController = viewController
        router.navigationController = viewController.navigationController
    }
    
}
