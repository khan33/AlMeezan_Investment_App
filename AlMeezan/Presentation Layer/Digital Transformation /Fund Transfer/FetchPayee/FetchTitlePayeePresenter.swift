//
//  AddPayeeValiatePresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 29/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class FetchTitlePayeePresenter: FetchTitlePayeePresenterProtocol {
    weak var viewController: FetchTitlePayeeViewProtocol?
    
    func bankList(_ response: bankListResponse) {
        viewController?.getlistOfBank(response)
    }
    
    func fetchTitleResponse(_ response: fetchTitleResponse) {
        viewController?.fetchTitleResponse(response)
    }
    
}
