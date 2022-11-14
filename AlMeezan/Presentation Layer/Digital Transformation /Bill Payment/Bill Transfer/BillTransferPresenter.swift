//
//  BillTransferPresenter.swift
//  AlMeezan
//
//  Created by Ahmad on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class BillTransferPresenter: BillTransferPresenterProtocol {
    
    weak var viewConroller: BillTransferViewProtocol?
    
    let errorHelper : ErrorMessageHelper
    init(error: ErrorMessageHelper) {
        self.errorHelper = error
    }
    
    func setupBillPayment(response: [BillTransferEntity.BillTransferResponse]) {
        viewConroller?.successBillPayment(response: response)
    }
    func showServerErrorMessage(error: String) {
        viewConroller?.showDataFailure(error: error)
    }
}
