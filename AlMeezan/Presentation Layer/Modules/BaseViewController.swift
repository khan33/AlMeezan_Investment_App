//
//  BaseViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 28/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectToSpecificScreen), name: .remoteNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.EServicesScreen), name: .eServicesNotification, object: nil)
    }
    
    @objc func redirectToSpecificScreen(notification: NSNotification) {
        let type  = notification.userInfo?["type"] as! String
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        if type == "FUND_REPORTS" {
            vc.urlStr = FUND_REPORTS
            vc.titleStr = "Fund Performance Report"
        } else if type == "blog" {
            vc.urlStr = BLOG_URL
            vc.titleStr = "Blogs & Articles"
        } else if type == "youtube" {
            vc.urlStr = YOUTUBE_CHANNEL
            vc.titleStr = "Awareness Videos"
        } else if type == "news" {
            vc.urlStr = NEWS_UPDATE
            vc.titleStr = "News Updates"
        }
        navigationController?.pushViewController(vc, animated: true)

    }
    @objc func EServicesScreen(notification: NSNotification) {
        let type  = notification.userInfo?["type"] as! String
        if type == "Investment" {
            
        } else if type == "Conversion" {
            
        } else if type == "redemption" {
            
        }
    }
    
    
    
}
