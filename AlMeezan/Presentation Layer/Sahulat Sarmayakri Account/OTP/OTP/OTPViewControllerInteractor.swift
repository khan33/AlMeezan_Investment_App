//
//  OTPViewControllerInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
class OTPViewControllerInteractor: OTPViewControllerInteractorProtocol {
    var presenter: OTPViewControllerPresenterProtocol?
    private var customerInfo: CustomerInfo?
    let container = DependencyContainer()
    let worker: OTPViewControllerWorkerProtocol
    required init(worker: OTPViewControllerWorkerProtocol) {
        self.worker = worker
    }
    
    func viewDidLoad() {
        
    }
    private func validate(cnic: String?, phone: String?, email: String?, simOwner: String?) -> Bool {
        let items = [
            ValidItem(name: .cnic, value: cnic, roles: [.required]),
            ValidItem(name: .phone, value: phone, roles: [.required]),
            ValidItem(name: .email, value: email, roles: [.email, .required]),
            ValidItem(name: .simOwner, value: simOwner, roles: [.required])
        ]
        return Validator.validate(items)
    }
    func didTapOnContinueBtn(cnic: String?, phone: String?, email: String?, simOwnerTxt: String?, simOwnerCode: String?) {
        
        let data = CustomerInfo(CNIC: cnic, email: email, mobileNO: phone, simOwner: simOwnerTxt, simOwnerCode: simOwnerCode)
        sendOTP(data: data)
        //saveCustomer(data: data)
    }
    
    func saveCustomer(data: CustomerInfo) {
        let encoder = JSONEncoder()
        if let encodedUser = try? encoder.encode(data) {
            defaults.set(encodedUser, forKey: OnlineOperationStatus.user.rawValue)
        }
    }
    func retriveCustomer() -> CustomerInfo? {
        Utility.shared.getUserdefaultValues(OnlineOperationStatus.user.rawValue, modelType: CustomerInfo.self) { (result) in
            self.customerInfo = result
        }
        return customerInfo
    }
    
    
    func sendOTP(data: CustomerInfo) {
        let requestData = OTPViewControllerEntity.OTPViewControllerRequest(cnic: data.CNIC, moible: data.mobileNO, email: data.email, simOwner: data.simOwner!)
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.generateOTP(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [OTPViewControllerEntity.OTPResponseModel] ) in
                        print("OTP Code = ", result)
                        self.presenter?.sendOTPSuccessfully(response: result)
                    }
                } else {
                    self.presenter?.dataFailure(error: "Invalid Json")
                }
                
            case .failure(let error):
                self.presenter?.dataFailure(error: error.localizedDescription)
            }
        }
    }
    
    func loadData() {
        let requestData = SetUpRequest()
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.setUpData(encryptedString: encryptedString) { result in
            switch result {
            case .success(let response):
                if let data = self.container.createDecryptionManger().decrypt(with: response) {
                    self.container.createCodeableManger().decodeObject(data, isCaching: false) { (dataResult: SetupModel ) in
                        Constant.setup_data = dataResult
                        self.presenter?.setupDataSuccess(data: dataResult)
                    }
                }
            case .failure(let error):
                self.presenter?.dataFailure(error: error.localizedDescription)
                
            }
        }

    }
    
}

