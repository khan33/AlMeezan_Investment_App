//
//  AddPayeePresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 22/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation






class AddPayeePresenter: AddPayeePresenterProtocol {
    weak var viewController: AddPayeeViewProtocol?
    
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel]) {
        viewController?.addPayee(response)
    }
    
}
