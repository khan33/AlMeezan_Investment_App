//
//  ContactInfoInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 26/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

protocol ContactInfoInteractorProtocol: AnyObject {
    func getCountries()
}

class ContactInfoInteractor:  ContactInfoInteractorProtocol {
    var presenter: ContactInfoPresetnerProtocol?
    let container = DependencyContainer()
    let worker: BankInfoWorkerProtocol
    required init(worker: BankInfoWorkerProtocol) {
        self.worker = worker
    }
    func getCountries() {
        let requestData = CountryRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.getCountry(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                print(response)
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: CountryModel ) in
                        self.presenter?.successData(resposne: dataResult)
                    }
                }
            case .failure(let error):
                print(error)
                self.presenter?.failedRequest()
            }
        }
    }
    
    
    
}


struct CountryRequest: Codable {
    var customerID  :   String?     =   KeychainWrapper.standard.string(forKey: "CustomerId")
    var password :   String?     =   KeychainWrapper.standard.string(forKey: "AccessToken")

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerID"
        case password = "AccessToken"
    }
}


class CountryRequestModel : RequestModel {
    private var KeyValue: String
    
    init(KeyValue: String) {
        self.KeyValue = KeyValue
    }
    
    override var path: String {
        return Constant.ServiceConstant.COUNTRY_CITY
    }
    
    override var body: [String : Any?] {
        return [
            "KeyValue"    : KeyValue
        ]
    }
    override var headers: [String : String] {
        return [
            "Content-Type" : "application/json"
        ]
    }
}


class BranchRequestModel : RequestModel {
    private var KeyValue: String
    
    init(KeyValue: String) {
        self.KeyValue = KeyValue
    }
    
    override var path: String {
        return Constant.ServiceConstant.BRANCH_LOCATOR
    }
    
    override var body: [String : Any?] {
        return [
            "KeyValue"    : KeyValue
        ]
    }
    override var headers: [String : String] {
        return [
            "Content-Type" : "application/json"
        ]
    }
}
