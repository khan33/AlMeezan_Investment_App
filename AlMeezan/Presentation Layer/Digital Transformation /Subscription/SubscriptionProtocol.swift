//
//  SubscriptionProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol SubscriptionInteractorProtocol: AnyObject {
    func viewDidLoad()
    func saveSubscribed(data: subcribedRequest)
}



// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol SubscriptionViewProtocol: MainViewProtocol {
    func subscriptionResponse(_ response: subscriptionResponse)
    func subcribedResponse(_ response: subcribedResponseModel)
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol SubscriptionPresenterProtocol: AnyObject {
    func subscriptionResponse(_ response: subscriptionResponse)
    func subcribedResponse(_ response: subcribedResponseModel)
}


// MARK: - ROUTER INPUT

protocol SubscriptionRouterProtocol: MainRouterProtocol {
    
}

// MARK: - WORKER

protocol SubscriptionWorkerProtocol: AnyObject {
    func serviceSubscribed(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func customerServiceSubscription(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
