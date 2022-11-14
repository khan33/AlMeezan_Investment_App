//
//  BillTrasanctionCompleteConfigurator.swift
//  AlMeezan
//
//  Created by Ahmad on 11/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit

protocol BillTransactionCompleteRouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get set}
    func backToPaymentServices()
}

class BillTransactionCompleteRouter: BillTransactionCompleteRouterProtocol {
    
    var navigationController: UINavigationController?
    
    func backToPaymentServices() {
        let vc = PaymentServicesViewController()
        PaymentServiceConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

class BillTransactionConfigurator {
    
    static func configureModule(viewController: BillPaymentTransactionComplete) {
        let router =  BillTransactionCompleteRouter()
        viewController.router = router
        router.navigationController = viewController.navigationController
    }
}
