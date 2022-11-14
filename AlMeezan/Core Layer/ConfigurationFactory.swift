//
//  ConfigurationFactory.swift
//  AlMeezan
//
//  Created by Atta khan on 13/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


protocol ValidationFactory {
    func createValidationManger() -> ValidationService
}

protocol EncryptionMangerFactory {
    func createEncryptionManger() -> EncryptionHelperProtocol
}

protocol DecryptionMangerFactory {
    func createDecryptionManger() -> DecryptionHelperProtocol
}

protocol CodableMangerFactory {
    func createCodeableManger() -> CodableHelper
}

extension DependencyContainer: EncryptionMangerFactory {
    func createEncryptionManger() -> EncryptionHelperProtocol {
        return EncryptionHelper()
    }
}

extension DependencyContainer: DecryptionMangerFactory {
    func createDecryptionManger() -> DecryptionHelperProtocol {
        return DecryptionHelper()
    }
}


extension DependencyContainer: CodableMangerFactory {
    func createCodeableManger() -> CodableHelper {
        return CodableHelper()
    }
}

extension DependencyContainer: ValidationFactory {
    func createValidationManger() -> ValidationService {
        return ValidationService()
    }

}


final class DependencyContainer {
//    private lazy var validation = ValidationService()
//    private lazy var codeableObj = CodableHelper()
//}
}
