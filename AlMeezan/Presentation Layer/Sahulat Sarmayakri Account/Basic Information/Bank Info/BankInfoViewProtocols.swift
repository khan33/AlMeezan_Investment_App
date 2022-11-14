//
//  BankInfoViewProtocols.swift
//  AlMeezan
//
//  Created by Atta khan on 12/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR

protocol BankInofoViewInteractorProtocol: AnyObject {
    func getBankName()
    func getBranchName()
    func saveData(basicInfo: PersonalInfoEntity.BasicInfo?, healthDec: HealthDec?, kyc: KYCModel?, fatca: FACTAModel?, crs: Crs?, riskProfile: RiskProfile?)
}


// MARK: - VIEW OUPUT (PRESENTER -> VIEW)

protocol BankInforViewProtocol: MainViewProtocol {
    func getBanklist(result: [BankInfoViewEntity.BankInfoResponseModel])
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func getBranch(response: [BranchLocator])
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)

protocol BankInforPresenterProtocol: ErrorMessageProtocol {
    func successData(response: [BankInfoViewEntity.BankInfoResponseModel])
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func getBranch(response: [BranchLocator])
    func failedRequest()
}


// MARK: - ROUTER INPUT

protocol BankInfoRouterProtocol: MainRouterProtocol {
    func nextOTPView()
}

// MARK: - WORKER

protocol BankInfoWorkerProtocol: AnyObject {
    func getBankInfo(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func submitApi(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func calculateRisk(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func getCountry(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
    func getBranchCity(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}
