//
//  NAVModel.swift
//  AlMeezan
//
//  Created by Atta khan on 17/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import ObjectMapper

class NAVModel: Mappable {
    var FundGroup           :   String?
    var NavPerformance      :  [NavPerformance1]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        FundGroup           <- map["FundGroup"]
        NavPerformance      <- map["NavPerformance"]
        
    }
}
class NavPerformance1: Mappable {
    var FundGroup           :   String?
    var FundiD              :   String?
    var Fundshortname       :   String?
    var RedemptionPrice     :   Double?
    var OfferPrice          :   Double?
    var NAVPrice            :   Double?
    var NAVDate             :   String?
    var MTD                 :   Double?
    var CYTD                :   Double?
    var CurrentFY           :   Double?
    var PreviousFY          :   Double?
    var FY                  :   Double?
    var SinceInception      :   Double?
    var fund_name           :   String?
    var description         :   String?
    var inceptiondate       :   String?
    var isExpandable        :   Bool = true
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        FundGroup           <- map["FundGroup"]
        FundiD              <- map["FundiD"]
        Fundshortname       <- map["Fundshortname"]
        RedemptionPrice     <- map["RedemptionPrice"]
        OfferPrice          <- map["OfferPrice"]
        NAVPrice            <- map["NAVPrice"]
        NAVDate             <- map["NAVDate"]
        MTD                 <- map["MTD"]
        CYTD                <- map["CYTD"]
        CurrentFY           <- map["CurrentFY"]
        PreviousFY          <- map["PreviousFY"]
        FY                  <- map["FY"]
        SinceInception      <- map["SinceInception"]
        fund_name           <- map["fund_name"]
        description         <- map["description"]
        inceptiondate       <- map["inceptiondate"]
    }
}
class NavHistoryModel: Mappable {
    var Fund_Name           :   String?
    var Fund_History        :   [NavHistory]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        Fund_Name           <- map["FUND_NAME"]
        Fund_History        <- map["History"]
    }
}
class NavHistory: Mappable {
    var FUND_NAME       :   String?
    var nav_date        :   String?
    var nav_value       :   Double?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        FUND_NAME       <- map["FUND_NAME"]
        nav_date        <- map["nav_date"]
        nav_value       <- map["nav_value"]
    }
}
class FundFilter: Mappable {
    var fund_name       :   String?
    var fund_id         :   String?
    var fund_mnemonic   :   String?
    var FundGroup       :   String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        fund_name       <- map["fund_name"]
        fund_id         <- map["fund_id"]
        fund_mnemonic   <- map["fund_mnemonic"]
        FundGroup       <- map["FundGroup"]
    }
}
