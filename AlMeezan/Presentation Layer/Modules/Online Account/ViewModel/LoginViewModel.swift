//
//  LoginViewModel.swift
//  AlMeezan
//
//  Created by Atta khan on 30/11/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import LocalAuthentication

@objc protocol LoginViewModelDelegate: class {
    @objc optional func didReceiveLoginSuccessResponse(loginResponse: [BiometricResponse])
    @objc optional func didReceiveLoginErrorResponse(errorResponse: [ErrorResponse]?)
    func notifyUser(_ msg: String, err: String?)

}


struct LoginViewModel {
    var delegate : LoginViewModelDelegate?
    let context = LAContext()
    var error: NSError?
    var biometricType: BiometricType {
        mutating get {
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                print(error?.localizedDescription ?? "")
                return .none
            }
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .none:
                    return .none
                case .touchID:
                    return .touchID
                case .faceID:
                    return .faceID
                }
            } else {
                return  .touchID
            }
        }
        
    }
    
    func getBiometricType (biometricType: BiometricType) -> String {
        switch biometricType {
        case .faceID:
            return BiometricType.faceID.rawValue
        case .touchID:
            return BiometricType.touchID.rawValue
        default:
            return BiometricType.none.rawValue
        }
    }
    
    mutating func biometricAuth(successResponse: @escaping (_ response: Bool) -> Void, fail: @escaping (_ error: Error) -> Void) {
        let cnxt = LAContext()
        if cnxt.canEvaluatePolicy(
                    LAPolicy.deviceOwnerAuthentication,
                    error: &error) {
            let reason = "Use your biometric to login to Al Meezan Investments Application."
            cnxt.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, evaluateError in
                if success {
                    DispatchQueue.main.async() {
                        successResponse(true)
                    }
                } else {
                    // Failed to authenticate
                    guard let error = evaluateError else {
                        return
                    }
                    print(error)
                    fail(error)
                
                }
            }
        }
        else {
            // Device cannot use biometric authentication
            if let err = error {
                switch err.code{
                    case LAError.Code.biometryNotEnrolled.rawValue:
                        self.delegate?.notifyUser("User is not enrolled",
                               err: err.localizedDescription)

                    case LAError.Code.passcodeNotSet.rawValue:
                        self.delegate?.notifyUser("A passcode has not been set",
                               err: err.localizedDescription)


                    case LAError.Code.biometryNotAvailable.rawValue:
                        self.delegate?.notifyUser("Biometric authentication not available",
                               err: err.localizedDescription)
                    default:
                        self.delegate?.notifyUser("Unknown error",
                               err: err.localizedDescription)
                }
                }
            }
                    
                
        
    }
    
    
    func login(_ customerId: String, _ passwordTxt: String, _ deviceID: String, _ deviceName: String, _ loginType: String) {
        let bodyParam = RequestBody(DeviceID: deviceID, UserId: customerId, UserPass:  passwordTxt, DeviceName: "iPhone14,3", Platform: "iOS", BiometricType: loginType)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: BIOMETRIC_LOGIN)!
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Biometric Login", modelType: BiometricResponse.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            if errorResponse?[0].errID != "00" {
                self.delegate?.didReceiveLoginErrorResponse?(errorResponse: errorResponse)
            }
        }, success: { (response) in
            //return the response we get from loginResource
            DispatchQueue.main.async {
                self.delegate?.didReceiveLoginSuccessResponse?(loginResponse: response)
            }
            
        }, fail: { (error) in
            print(error.localizedDescription)
            
        }, showHUD: true)
    }
}
