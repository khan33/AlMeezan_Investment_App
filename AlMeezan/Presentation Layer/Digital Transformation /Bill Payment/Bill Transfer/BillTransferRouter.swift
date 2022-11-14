//
//  BillTransferRouter.swift
//  AlMeezan
//
//  Created by Ahmad on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillTransferRouter: BillTransferRouterProtocol {
    var navigationController: UINavigationController?
    
    func nextToVerifyPayment() {
        
    }
    
    func successScreen() {
        let vc = BillPaymentTransactionComplete()
        BillTransactionConfigurator.configureModule(viewController: vc)
//        vc.billTransfer = self?.billTransferResponse
//        vc.amountView.subLbl.text =  "PKR \(Double(self?.amountTxt ?? "") ?? 0.0)"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
