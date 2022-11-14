//
//  OTPVerificationInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 03/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
class OTPVerificationInteractor: OTPVerificationInteractorProtocol {
    //MARK: Properties
    var presenter: OTPVerificationPresenterProtocol?
    let container = DependencyContainer()
    let worker: OTPVerificationWorkerProtocol
    required init(worker: OTPVerificationWorkerProtocol) {
        self.worker = worker
    }
    
    func verifyPinCode(code: String?) {
        let items = [ ValidItem(name: .code, value: code, roles: [.required])]
        if Validator.validate(items) {
            let cnic = UserDefaults.standard.string(forKey: "CNIC")
            let requestData = OTPVerificationEntity.OTPVerifyRequest(cnic: cnic, code: code)
            let jsonString = container.createCodeableManger().encodeToString(from: requestData)
            let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
            print(encryptedString)
            
            worker.VerifyOTP(encryptedString: encryptedString) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let resposne):
                        if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                            self.container.createCodeableManger().decodeObject(data, isCaching: false) { (result: OTPVerificationEntity.OTPVerificationResponseModel ) in
                                print(result)
                                self.presenter?.OTPVerifcationData(response: result)
                            }
                        } else {

                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        else {
            self.presenter?.OTPFailedData()
        }
    }
    
    func resendOTP(info: CustomerInfo) {
        let requestData = OTPViewControllerEntity.OTPViewControllerRequest(cnic: info.CNIC, moible: info.mobileNO, email: info.email, simOwner: info.simOwner!)
        let jsonString = container.createCodeableManger().encodeToString(from: requestData)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        
        worker.generateOTP(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [OTPViewControllerEntity.OTPResponseModel] ) in
                        self.presenter?.OTPResendSuccessfully(response: result)
                    }
                } else {
                    self.presenter?.OTPFailedData()
                }
                
            case .failure(let error):
                self.presenter?.OTPFailedData()
                print(error.localizedDescription)
            }
        }
    }
    
    
}
