//
//  LoginProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 23/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


// VIEW -> INTERACTOR
protocol LoginInteractorProtocol: AnyObject {
    func viewDidLoad()
    func didTapOnLoginBtn(customer_id: String, password: String )
    func back(isTransition: Bool, navigationController: UINavigationController)
}

// INTERACTOR -> PRESENTER
protocol LoginPresenterProtocol: AnyObject {
    func interactor(didFetchUser user: [LoginEntity.LoginResponseModel] )
    func interactor(didFailValidation error: Error)
}



// PRESENTER -> VIEW

protocol LoginPresenterOutput: AnyObject {
    func successfulLogin(viewModel: [LoginEntity.LoginViewModel])
    func presenter(didFailValidation message: String)
}

// WORKER

protocol LoginWorkerProtocol: AnyObject {
    func login(encryptedString: String, completion: @escaping (Swift.Result<String, Error>) -> Void)
}


// ROUTER
protocol LoginRouterProtocol: AnyObject {
    
    var navigationController: UINavigationController? { get set }
    func routeToDashboard()
}
