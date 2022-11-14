//
//  NAVProtocol.swift
//  AlMeezan
//
//  Created by Atta khan on 11/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import UIKit


protocol NAVViewProtocol : class {
}
protocol NAVPresenterProtocol : class {
    
    // VIEW -> PRESENTER
    func viewDidLoad()
    func viewWillAppear(navigationController:UINavigationController)
}

protocol NAVInteractorInputProtocol: class {
   
}

protocol NAVInteractorOutputProtocol {
    
}
protocol NAVRouterProtocol {
    
}
