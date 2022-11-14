//
//  SurveyViewPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 19/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


protocol SurveyViewPresetnerProtocol {
    func response(with response: [SurveyResponseModel])
}


class SurveyViewPresenter: SurveyViewPresetnerProtocol {
    weak var viewController: SurveyViewControllerProtocol?

    func response(with response: [SurveyResponseModel]) {
        if response.count > 0 {
            viewController?.response(with: response[0])
        }
    }
    
}
