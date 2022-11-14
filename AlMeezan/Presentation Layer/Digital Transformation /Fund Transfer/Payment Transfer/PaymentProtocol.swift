//
//  PaymentProtocol.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 05/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol PaymentInteractorProtocol: AnyObject {
    
    //IBFTResponseModel
    
    func payPayment(_ reqeust: FundTransferEntity.FundTransferRequest)
    
    
    
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol PaymentViewProtocol: MainViewProtocol {
    func paymentResponse(_ response: [FundTransferEntity.IBFTResponseModel])
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol PaymentPresenterProtocol: AnyObject {
    func paymentResponse(_ response: [FundTransferEntity.IBFTResponseModel])

}


// MARK: - ROUTER INPUT

protocol PaymentRouterProtocol: MainRouterProtocol {
    
}
