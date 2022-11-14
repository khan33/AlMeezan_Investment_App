//
//  ErrorModel.swift
//  AlMeezan
//
//  Created by Atta khan on 10/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//
import UIKit

class ErrorModel: Error {
    
    // MARK: - Properties
    
    var messageKey: String
    var message: String {
        return messageKey.localizedLowercase
    }
    init(_ messageKey: String) {
        self.messageKey = messageKey
    }
}

// MARK: - Public Function

extension ErrorModel {
    
    class func generalError() -> ErrorModel {
        return ErrorModel(ErrorKey.general.rawValue)
    }
    
}

enum ErrorKey: String {
    case general = "Error_general"
    case parsing = "Error_parsing"
}

