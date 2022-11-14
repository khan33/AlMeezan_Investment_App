//
//  ForexRouter.swift
//  AlMeezan
//
//  Created by Atta khan on 14/09/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
protocol ForexRouterProtocol: class {
    
    var navigationController: UINavigationController? { get }
}

class ForexRouter: ForexRouterProtocol {
    weak var navigationController: UINavigationController?
}
