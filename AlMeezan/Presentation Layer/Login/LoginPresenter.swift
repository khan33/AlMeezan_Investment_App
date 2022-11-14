//
//  LoginPresenter.swift
//  AlMeezan
//
//  Created by Atta khan on 10/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import FirebaseCrashlytics


class LoginPresenter: LoginPresenterProtocol {
    weak var viewConroller: LoginViewController?
    let errorHelper : ErrorMessageHelper = ErrorMessageHelper()
    
    func interactor(didFetchUser user: [LoginEntity.LoginResponseModel]) {
        let mapped = user.map {
            LoginEntity.LoginViewModel(statusCode: $0.statusCode, customerid: $0.customerid, tokenID: $0.tokenID, dataStatus: $0.dataStatus, errorId: $0.errId)
        }
        let hasErrorId = mapped[0].hasErrorid
        if hasErrorId {
            
            let message = errorHelper.returnErrorMessage(id: mapped[0].errorId ?? "")
            viewConroller?.presenter(didFailValidation: message)
            
        } else {
            if let customer_id = mapped[0].customerid {
                KeychainWrapper.standard.set(customer_id, forKey: "CustomerId")
                Crashlytics.crashlytics().setUserID(customer_id)
            }
            if let token = mapped[0].tokenID {
                KeychainWrapper.standard.set(token, forKey: "AccessToken")
                KeychainWrapper.standard.set("loggedInUser", forKey: "UserType")
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .tabBarSwitchNotifications, object: nil, userInfo: ["Index": 8])
                NotificationCenter.default.post(name: .menuItemsSwitchNotifications, object: nil)
            }
            viewConroller?.successfulLogin(viewModel: mapped)
        }
    }
    
    func interactor(didFailValidation error: Error) {
        viewConroller?.presenter(didFailValidation: error.localizedDescription)
    }
    
    
    
}
