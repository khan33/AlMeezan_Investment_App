//
//  LoginInteractor.swift
//  AlMeezan
//
//  Created by Atta khan on 09/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import LocalAuthentication


class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?
    let context = LAContext()
    var error: NSError?
    let worker: LoginWorkerProtocol
    let container = DependencyContainer()
    
    required init(worker: LoginWorkerProtocol) {
        self.worker    = worker
    }
    
    var biometricType: BiometricType {
        get {
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
    
    
    
    func viewDidLoad() {
        
    }
    
    private func getDevice() -> String {
        return UserDefaults.standard.string(forKey: "device_id") ?? ""
    }
    
    private func getGuestKey() -> String {
        return UserDefaults.standard.string(forKey: "guestkey") ?? ""
    }
    
    private func getBiometricType() -> String {
        var loginType   =   LoginType.manual.rawValue
        switch biometricType {
        case .faceID:
            loginType = LoginType.faceId.rawValue; break
        case .touchID:
            loginType = LoginType.touchId.rawValue; break
        default:
            break
        }
        return loginType
    }
    
    
    func didTapOnLoginBtn(customer_id: String, password: String) {
        do {
            let customerId = try container.createValidationManger().validateLoginField(customer_id)
            let password = try container.createValidationManger().validateLoginField(password)
            let device_id = getDevice()
            let guest_key = getGuestKey()
            let loginType = getBiometricType()
            
            let data = LoginEntity.LoginRequest(customerID: customerId, password: password, device_id: device_id, guest_key: guest_key, loginType: loginType)
            
            let jsonString = container.createCodeableManger().encodeToString(from: data)
            let encryptedString = container.createEncryptionManger().encrypt(withString: jsonString)
            
            worker.login(encryptedString: encryptedString) { result in
                switch result {
                case .success(let resposne):
                    print(resposne)
                    if let data = self.container.createDecryptionManger().decrypt(with: resposne) {
                        
                        self.container.createCodeableManger().decodeArray(data, isCaching: false) { (result: [LoginEntity.LoginResponseModel] ) in
                            self.presenter?.interactor(didFetchUser: result)
                        }
                    } else {
                        // data is empty
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } catch {
            presenter?.interactor(didFailValidation: error)
        }
    }
    
    func back(isTransition: Bool, navigationController: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = ViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        navigationController.pushViewController(vc, animated: false)
    }
    
}
