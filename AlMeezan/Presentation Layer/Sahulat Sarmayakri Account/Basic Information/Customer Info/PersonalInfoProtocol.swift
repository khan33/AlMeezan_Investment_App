//
//  PersonalInfoProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 13/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation

// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol PersonalInfoInteractorProtocol: BasicInfoInteractorProtoocl {
    
}

// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol PersonalInfoViewProtocol: MainViewProtocol {
    func sucessResponse(resposne : [SubmissionResponse])
    func failureResponse()
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol PersonalInfoPresenterProtocol: ErrorMessageProtocol {
    func successData(response: [SubmissionResponse])
    func failedRequest()
}




// MARK: - ROUTER INPUT
protocol PersonalInfoRouterProtocol: MainRouterProtocol {
    var navigationController: UINavigationController? { get set}
    func routerToContactInfoVC(info: PersonalInfoEntity.BasicInfo)
    func routerToHealthDec(info: PersonalInfoEntity.BasicInfo)
}

// MARK: - WORKER

protocol PersonalInfoWorkerProtocol: BasicInfoWorker {
    func getBankInfo(encryptedString: String, completion: @escaping (Result<String, ErrorModel>) -> Void)
}
