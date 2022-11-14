//
//  NAVPresentor.swift
//  AlMeezan
//
//  Created by Atta khan on 11/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import UIKit
class NAVPresenter  : NAVPresenterProtocol {
    var router: NAVRouterProtocol?
    var interactor: NAVInteractorInputProtocol?
    var view: NAVViewProtocol?
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear(navigationController: UINavigationController) {
        navigationController.setNavigationBarHidden(true, animated: true)

    }
    
}
extension NAVPresenter : NAVInteractorOutputProtocol {
    
    
    
}
