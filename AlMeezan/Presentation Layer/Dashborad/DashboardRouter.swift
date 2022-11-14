//
//  DashboardRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 15/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
protocol DashboardRouterProtocol: class {
    var navigationController: UINavigationController? { get set }
}

class DashboardRouter: DashboardRouterProtocol {
    weak var navigationController: UINavigationController?
}
