//
//  BasicInfoProtocols.swift
//  AlMeezan
//
//  Created by Atta khan on 23/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation


// MARK: - VIEW INPUT ( VIEW -> INTERACTOR
protocol BasicInfoInteractorProtoocl: AnyObject {
    func saveData(basicInfo: PersonalInfoEntity.BasicInfo?, healthDec: HealthDec?, kyc: KYCModel?, fatca: FACTAModel?, crs: Crs?, riskProfile: RiskProfile?)
}

// MARK: - INTERACTOR INPUT (INTERACTOR -> PRESENTER)
protocol BasicInfoPresenterProtocol: AnyObject {
    func SaveDatasuccessfully(response: [SubmissionResponse])
    func FailureResponse()
}

// MARK: - VIEW OUPUT (PRESENTER -> VIEW)
protocol BasicInfoViewProtoocl: AnyObject {
    func SaveDatasuccessfully(response: [SubmissionResponse])
}

// MARK: - Worker

protocol BasicInfoWorkerProtocol: AnyObject {
    func saveData(encryptedString: String, completion: @escaping (Result<String, Error>) -> Void)
}



extension BasicInfoInteractorProtoocl {
    func saveData(basicInfo: PersonalInfoEntity.BasicInfo?, healthDec: HealthDec?, kyc: Kyc?, fatca: Fatca?, crs: Crs?, riskProfile: RiskProfile?) {
        
    }
}
