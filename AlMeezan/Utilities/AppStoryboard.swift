//
//  AppStoryboard.swift
//  AlMeezan
//
//  Created by Atta khan on 20/10/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import Foundation

enum AppStoryboard: String {
    case main = "Main"
    case home = "Home"
    case marketWatch = "Marketwatch"
    case onlineAccount = "OnlineAccount"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
    func initalViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
}
