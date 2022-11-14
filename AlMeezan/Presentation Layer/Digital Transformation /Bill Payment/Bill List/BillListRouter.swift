//
//  Router.swift
//  AlMeezan
//
//  Created by Ahmad on 28/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillListRouter: BillListRouterProtocol {
   var navigationController: UINavigationController?
}

extension BillListRouter {
    func nextoToAddBill() {
        let vc = AddBillController()
        AddBillConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
}
