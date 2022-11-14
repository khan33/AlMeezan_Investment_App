//
//  BankInfoViewPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 12/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
class BankInfoViewPresenter: BankInforPresenterProtocol {
    
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response.count > 0 {
            viewController?.SaveDatasuccessfully(response: response)
        }
    }
    
    weak var viewController: BankInforViewProtocol?
    
    func successData(response: [BankInfoViewEntity.BankInfoResponseModel]) {
        if response.count > 0 {
            viewController?.getBanklist(result: response)
        }
    }
    func failedRequest() {
        
    }
    func getBranch(response: [BranchLocator]) {
        viewController?.getBranch(response: response)
    }
}
