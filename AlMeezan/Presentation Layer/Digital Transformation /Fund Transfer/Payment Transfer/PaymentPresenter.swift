//
//  PaymentPresenter.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
class PaymentPresenter: PaymentPresenterProtocol {
    weak var viewController: PaymentViewProtocol?
    func paymentResponse(_ response: [FundTransferEntity.IBFTResponseModel]) {
        viewController?.paymentResponse(response)
    }
}
