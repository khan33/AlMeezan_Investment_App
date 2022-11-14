//
//  ErrorMessageHelper.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation


struct ErrorMessage: Decodable {
    var errors: [ErrorMessageModel]
}
struct ErrorMessageModel : Decodable {
    var message : String
    var id      : String
}

protocol ErrorMessageProtocol {
    func returnErrorMessage() -> String
}

class ErrorMessageHelper {
    var messages: [ErrorMessageModel]?
    func returnErrorMessage(id: String) -> String {
        messages = loadJson(filename: "ErrorMessage")
        let obj = messages?.filter { $0.id == id }
        return obj?[0].message ?? ""
    }
    
    func loadJson(filename fileName: String) -> [ErrorMessageModel]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([ErrorMessageModel].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}

extension ErrorMessageProtocol {
    func returnErrorMessage() -> String {
        return ""
    }
}


enum StatusCode: String, Codable {
    case SuccessfulLogin        =   "001"
    case UnsuccessfulLogin      =   "002"
    case NotFound               =   "101"
    case InsufficientBalance    =   "105"
    case ParameterNotFound      =   "106"
    case InvalidUser            =   "102"
    case AlreadyRegistration    =   "108"
    case NonRegisterCustomer    =   "104"
    case RequestSent            =   "201"
    case SessionExpire          =   "103"
    case ComplainFailed         =   "107"
    case ValidSubscription      =   "109"
    case RegisteredCustomer     =   "110"
    case RegisteredCNIC         =   "210"
    case ExistedUser            =   "211"
    case ExistedUserOnline      =   "212"
    case EmptyField             =   "213"
    case IvalidSMSorEmail       =   "214"
    case ThresholdAmount        =   "215"
    case DormatAccount          =   "2l6"
    case UnderProcess           =   "217"
}
