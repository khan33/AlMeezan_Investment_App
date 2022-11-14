//
//  BasicInfoPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 23/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class BasicInfoPresenter: BasicInfoPresenterProtocol {
    weak var viewController: BasicInfoViewProtoocl?
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response.count > 0 {
            viewController?.SaveDatasuccessfully(response: response)
        }
    }
    func FailureResponse() {
        
    }
    
   
}
