//
//  RiskProfilePresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 25/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
protocol RiskProfilePresenterProtocol: AnyObject {
    func getSuccessdata(response: RiskProfileEntity.RiskProfileResponseModel)
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func failureData()
}

protocol RiskProfileViewProtocol: AnyObject {
    func getSuccessdata(response: RiskProfileEntity.RiskProfileResponseModel)
    func failureData()
    func SaveDatasuccessfully(response: [SubmissionResponse])
}

class RiskProfilePresenter: RiskProfilePresenterProtocol {
    weak var viewController: RiskProfileViewProtocol?
    
    func getSuccessdata(response: RiskProfileEntity.RiskProfileResponseModel) {
        viewController?.getSuccessdata(response: response)
    }
    func failureData() {
        viewController?.failureData()
    }
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response.count > 0 {
            viewController?.SaveDatasuccessfully(response: response)
        }
    }
    
}
