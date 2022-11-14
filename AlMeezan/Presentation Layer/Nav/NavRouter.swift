//
//  NavRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation



class NavRouter: NavRouterProtocol {
    weak var navigationController: UINavigationController?
    
    func routerToNavSummery(with index: Int, nav_data: [NavEntity.NavViewModel.DisplayedFund]) {
        let viewController = NAVSummeryVC.instantiateFromAppStroyboard(appStoryboard: .main)
        SummeryConfigurator.configureModule(fundId: index, data: nav_data, viewController: viewController)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
