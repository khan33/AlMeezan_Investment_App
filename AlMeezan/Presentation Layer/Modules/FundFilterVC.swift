//
//  FundFilterVC.swift
//  AlMeezan
//
//  Created by Atta khan on 16/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftKeychainWrapper


class FundFilterVC: UIViewController {

    var fund_value: Int?
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countNotificationLbl: UIButton!

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var fundCountLbl: UILabel!
    var fundFilter: [FundSuggestion]?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let score = fund_value {
            profileLbl.text = checkProfileByScore(score)
        }
         countNotificationLbl.isHidden = true
        getData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
        
        Utility.shared.renderNotificationCount(countNotificationLbl)
    }
    
    func configTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 66.0
        tableView.registerCells([NAVHeaderCell.self, ContactViewCell.self])
        tableView.backgroundColor = UIColor.rgb(red: 244, green: 246, blue: 250, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func getData() {
        let bodyParam = RequestBody(Score: fund_value)
        let bodyRequest = bodyParam.encryptData(bodyParam)
        
        let url = URL(string: FUND_SUGGESTION)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Fund Description", modelType: FundSuggestion.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.fundFilter = response
            let count = self.fundFilter?.count ?? 0
            self.fundCountLbl.text =  String(describing: count)
            self.configTableView()
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
        
    }
    
    
    @IBAction func navigateBackController(_ sender: Any) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
}
extension FundFilterVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = fundFilter?.count ?? 0
        return  count + 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let lastSection = tableView.numberOfSections
        let count = fundFilter?.count ?? 0 + 1
        print("section is = ",indexPath.section)
        if (indexPath.section == lastSection - 1) {
            let cell = tableView.dequeueReusableCell(with: ContactViewCell.self, for: indexPath)
            cell.contactTopView.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 10, borderColor: UIColor.rgb(red: 244, green: 246, blue: 250, alpha: 1), borderWidth: 0)
            let gesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBtn))
            cell.contactTopView.addGestureRecognizer(gesture)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: NAVHeaderCell.self, for: indexPath)
            let randomFloat = Float.random(in: 0.5..<1)
            cell.cellView.backgroundColor = UIColor.rgb(red: 138.0, green: 38.0, blue: 155.0, alpha: CGFloat(randomFloat))
            cell.fundTitleLbl.text = fundFilter?[indexPath.section].fund_name
            cell.fundTitleLbl.textColor = UIColor.white
            cell.tapBtn.tag = indexPath.section
            cell.tapBtn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lastSection = tableView.numberOfSections
        if (indexPath.section == lastSection - 1) {
            return UITableView.automaticDimension
        }
        return 60.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 244.0 / 255.0, green: 246.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    @objc func handleTap(_ sender: UIButton) {
        let tag = sender.tag
        let vc = InvestmentProductDetailVC.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.fund_name = fundFilter?[tag].fund_name
        vc.fund_short_name = fundFilter?[tag].fund_mnemonic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func tapOnBtn(){
        let vc = InvestViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
