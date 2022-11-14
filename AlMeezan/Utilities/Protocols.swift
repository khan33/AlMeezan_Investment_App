//
//  Protocol.swift
//  AlMeezan
//
//  Created by Atta khan on 03/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation

protocol CityProtocol: class {
    func getCityBranches(_ brnach: City?)
    func getCities(_ city: String)
}
protocol BranchProtocol: AnyObject {
    func getBranches(_ branch: Branches?)
}
protocol InvestmentEservices: class {
    func submitInvestment()
}
