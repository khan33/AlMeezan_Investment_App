//
//  PaymentServicePresenter.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 31/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
class PaymentServicePresenter: SubscriptionPresenterProtocol {
    weak var viewController: SubscriptionViewProtocol?
    func subscriptionResponse(_ response: subscriptionResponse) {
        viewController?.subscriptionResponse(response)
    }
    func subcribedResponse(_ response: subcribedResponseModel) {
        
    }
}
