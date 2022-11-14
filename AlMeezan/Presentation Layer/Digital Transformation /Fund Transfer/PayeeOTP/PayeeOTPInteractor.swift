//
//  PayeeOTPInteractor.swift
//  AlMeezan
//
//  Created by Muhammad, Atta on 04/10/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


class PayeeOTPInteractor: PayeeOTPInteractorProtocol {
    
    var presenter: PayeeOTPPresenterProtocol?
    let container = DependencyContainer()
    let worker: FundTransferWorkerProtocol
    required init(worker: FundTransferWorkerProtocol) {
        self.worker = worker
    }
    func otpVerify(_ data: otpVerificationReqeust) {
        let jsonString = container.createCodeableManger().encodeToString(from: data)
        let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
        worker.OTPVerification(encryptedString: encryptedString) { result in
            switch result {
            case .success(let resposne):
                if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                    self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: otpVerifcationResponse ) in
                        print(result)
                        self.presenter?.otpVerificationResponse(result)
                    }
                } else {
                   print(resposne)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
