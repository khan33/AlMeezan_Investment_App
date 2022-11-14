//
//  PersonalInfoPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 12/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

class PersonalInfoPresenter: PersonalInfoPresenterProtocol {
    weak var viewConteroller: PersonalInfoViewProtocol?
    func successData(response: [SubmissionResponse]) {
        viewConteroller?.sucessResponse(resposne: response)
    }
    
    func failedRequest() {
        
    }
}
