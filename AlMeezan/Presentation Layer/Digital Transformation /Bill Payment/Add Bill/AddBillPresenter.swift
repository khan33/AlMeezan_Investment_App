//
//  AddBillPresenter.swift
//  AlMeezan
//
//  Created by Ahmad on 30/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class AddbillPresenter: AddBillPresenterProtocol {
    
    weak var viewConroller: AddBillViewProtocol?
    
    let errorHelper : ErrorMessageHelper
    init(error: ErrorMessageHelper) {
        self.errorHelper = error
    }

    func setupAddBillMerchantList(response: [AddBillEntity.AddBillResponse]) {
        viewConroller?.successBillList(response:response)
    }
    func setupBillInquiry(response: [BillInquiryEntity.BillInquiryResponse]) {
        viewConroller?.successBillInquiry(response: response)
    }
    
    func setupBillAdd(response: [BillAddEntity.BillAddResponse]) {
        viewConroller?.successBillAdd(response: response)
    }
    
    func showServerErrorMessage(error: String) {
        viewConroller?.showDataFailure(error: error)
    }
    
}
