//
//  ContactInfoPresetner.swift
//  AlMeezan
//
//  Created by Atta khan on 26/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

protocol ContactInfoPresetnerProtocol: AnyObject {
    func successData(resposne: CountryModel)
    func failedRequest()
}
protocol ContactInfoViewProtocol: MainViewProtocol {
    func getCountries(resposne: CountryModel)
    func requestFail()
}


class ContactInfoPresetner: ContactInfoPresetnerProtocol {
    weak var viewcontroller: ContactInfoViewProtocol?
    
    func successData(resposne: CountryModel) {
        viewcontroller?.getCountries(resposne: resposne)
    }
    func failedRequest() {
        
    }
}
