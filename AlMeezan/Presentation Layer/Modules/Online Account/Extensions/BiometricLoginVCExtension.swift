//
//  BioLoginVCExtension.swift
//  AlMeezan
//
//  Created by Atta khan on 30/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import FirebaseCrashlytics

extension BioAuthViewController : LoginViewModelDelegate
{
    func didReceiveLoginSuccessResponse(loginResponse: [BiometricResponse]){
        if let userId = loginResponse[0].userID, let passToken = loginResponse[0].passToken {
            KeychainWrapper.standard.set(userId, forKey: "BioMetricCustomerId")
            Crashlytics.crashlytics().setUserID(userId)
            UserDefaults.standard.setValue(true, forKey: "isBiometricLogin")
            KeychainWrapper.standard.set(passToken, forKey: "BioMetricAccessToken")
            var message = ""
            switch loginViewModel.biometricType {
            case .faceID:
                message = "Your Face ID has been successfully registered."
            case .touchID:
                message = "Your Finger Print has been successfully registered."
            default:
                break
            }
            self.showAlert(title: "Alert", message: message, controller: self) {
                NotificationCenter.default.post(name: .checkBiometricStatus, object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func didReceiveLoginErrorResponse(errorResponse: [ErrorResponse]?) {
        if let error = errorResponse {
            self.showErrorMsg(error)
        }
    }
    
    func notifyUser(_ msg: String, err: String?) {
        let alert = UIAlertController(title: msg,
            message: err,
            preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "OK",
            style: .cancel, handler: nil)

        alert.addAction(cancelAction)

        self.present(alert, animated: true,
                            completion: nil)
    }
}


