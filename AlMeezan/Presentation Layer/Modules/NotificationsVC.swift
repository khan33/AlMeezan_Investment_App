//
//  NotificationsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 20/01/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper

class NotificationsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var notification_title_lbl: UILabel!
    @IBOutlet weak var notification_details_Lbl: UITextView!
    var notification_list: [NotificationList]?
    var notification_status : [NotificationResponse]?
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        getNotificationData(true)
         countNotificationLbl.isHidden = true
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
        notification_details_Lbl.font = UIFont(name: "CircularStd-Book", size: 11)
//        estimatedFrameForTxt(text: messageTxt).width + 32
        notificationPopup(true)
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        if #available(iOS 10, *){
           tableView.refreshControl = refreshControl
        } else {
           tableView.addSubview(refreshControl)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.configTableView()
        Utility.shared.renderNotificationCount(self.countNotificationLbl)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    private func estimatedFrameForTxt(text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: option, attributes: [ NSAttributedString.Key.font: UIFont(name: "CircularStd-Book", size: 11)], context: nil)
    }
    @objc private func refreshTableViewData(_ sender: Any) {
       getNotificationData(false)
    }
    func notificationReader(_ id: String) {
        let url = URL(string: NOTIFICATION_READER)!
        let bodyParam = RequestBody(MSGID: id)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Notification Reader", modelType: NotificationResponse.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.notification_status = response
            totalUnreadNotify = totalUnreadNotify - 1
            DispatchQueue.main.async {
                Utility.shared.renderNotificationCount(self.countNotificationLbl)
            }
            
            self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
        
        
    }
    
    
    func getNotificationData(_ show: Bool) {
        
        var guest_key = ""
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth != "loggedInUser" {
                if let key = UserDefaults.standard.string(forKey: "guestkey") {
                    guest_key = key
                }
            }
        }
        let bodyParam = RequestBody(Key:guest_key)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        let url = URL(string: NOTIFICATION_LIST)!
        if show {
            SVProgressHUD.show()
        }
        
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Notification list", modelType: NotificationList.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.notification_list = response
            if let id = self.notification_list?[0].id {
                let filterList = self.notification_list?.filter( { $0.read == 0 } )
                totalUnreadNotify = filterList?.count ?? 0
                UserDefaults.standard.set(totalUnreadNotify, forKey: "totalNotification")
                Utility.shared.renderNotificationCount(self.countNotificationLbl)
                self.refreshControl.endRefreshing()
                self.configTableView()
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
       
    }
    func configTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.register(NotifyViewCell.nib, forCellReuseIdentifier: NotifyViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
    }
    
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
    }

    @IBAction func tapOnMenuBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapOnCloseBtn(_ sender: Any) {
        notificationPopup(true)
    }
    
    func notificationPopup(_ flag: Bool) {
        
        notificationView.isHidden = flag
        blurView.isHidden = flag
    }
}
extension NotificationsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfSections: Int = 0
        if (NetworkState().isInternetAvailable) || notification_list?.count ?? 0 == 0 {
            tableView.backgroundView = nil
            numOfSections = notification_list?.count ?? 0
        } else {
            Utility.shared.emptyTableView(tableView)
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotifyViewCell.identifier) as! NotifyViewCell
        let status = notification_list?[indexPath.row].read
        if status == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.06)
            
        }
        cell.data = notification_list?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if let id = notification_list?[indexPath.row].rId, let status = notification_list?[indexPath.row].read {
            if status == 0 {
                notificationReader(String(id))
                notification_list?[indexPath.row].read = 1
            }
        }
        if let type = notification_list?[indexPath.row].destination {
            notification_title_lbl.text = notification_list?[indexPath.row].title
            notification_details_Lbl.text = notification_list?[indexPath.row].body
            if let messageTxt = notification_list?[indexPath.row].body {
//                heightConstraint.constant = estimatedFrameForTxt(text: messageTxt).height + 180
                let TxtViewHeight = estimatedFrameForTxt(text: messageTxt).height + 180
                if TxtViewHeight > SCREEN_HEGHT - 120 {
                    notification_details_Lbl.isScrollEnabled = true
                    heightConstraint.constant = SCREEN_HEGHT - 120
                } else {
                    heightConstraint.constant = TxtViewHeight
                }
            }
            
            
            
            if type == Destination.nav.rawValue {
                let vc = NAVViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if type == Destination.blog.rawValue {
                let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                vc.urlStr = BLOG_URL
                vc.titleStr = "Blogs & Articles"
                navigationController?.pushViewController(vc, animated: true)
            } else if type == Destination.fmr.rawValue {
                let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                vc.urlStr = FUND_REPORTS
                vc.titleStr = "Fund Performance Report"
                navigationController?.pushViewController(vc, animated: true)
                
            } else if type == Destination.mkt.rawValue {
                notificationPopup(false)
            } else if type == Destination.lead.rawValue {
                notificationPopup(false)
            } else if type == Destination.investment.rawValue {
                notificationPopup(false)
            } else if type == Destination.conversion.rawValue {
                notificationPopup(false)
            } else if type == Destination.redemption.rawValue {
                notificationPopup(false)
            } else if type == Destination.news.rawValue {
                let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                vc.urlStr = NEWS_UPDATE
                vc.titleStr = "News Updates"
                navigationController?.pushViewController(vc, animated: true)
            } else if type == Destination.youtube.rawValue {
               let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
               vc.urlStr = YOUTUBE_CHANNEL
               vc.titleStr = "Awareness Videos"
               navigationController?.pushViewController(vc, animated: true)
            } else if type == Destination.reg.rawValue {
                notificationPopup(false)
            } else {
                notificationPopup(false)
            }
        }

    }
    
}
