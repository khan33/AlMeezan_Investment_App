//
//  SummeryConfigurator.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation

class SummeryConfigurator {
    
    static func configureModule(fundId: Int, data: [NavEntity.NavViewModel.DisplayedFund], viewController: NAVSummeryVC) {
        let interactor = SummeryInteractor(worker: SummeryWorker())
        let presenter = SummeryPresenter()
        let router = SummeryRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        viewController.selectedFundId = fundId
        viewController.nav_data = data
        
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.navigationController = viewController.navigationController
    }
}
