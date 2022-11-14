//
//  AccountTypeVC.swift
//  AlMeezan
//
//  Created by Atta khan on 16/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class AccountTypeVC: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "2 / 9", titleStr: AppString.Heading.SSA, subTitle: AppString.Heading.selectFund, numberOfPages: 0, currentPageNo: 0, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.previousBtn.isHidden = true
        view.nextBtn.isHidden = true
        view.lblStep.isHidden = true
        return view
    }()
    
    
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    var accountView: FundRoundedView!
    var router: AccountTypeRouterProtocol?
    var accountType: [AccountType]?
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        view.backgroundColor = UIColor.init(rgb: 0xF4F5F8)
        if let chanel = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            if chanel == "SSA" {
                headerView.lblTitle.text = AppString.Heading.SSA
            } else {
                headerView.lblTitle.text = "Digital Account"
            }
        }
        accountType = Constant.CustomerData.customer_data?.accountType
        setupViews()
    }
}
extension AccountTypeVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 124.0).isActive = true
        
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        
        for (index, _) in (accountType?.enumerated())! {
            var accountView: FundRoundedView = { [unowned self] in
                let view = FundRoundedView.init(heading: accountType?[index].name ?? "", desc: accountType?[index].desc ?? "", image: accountType?[index].code ?? "") {
                    let account_type_code = accountType?[index].code
                    UserDefaults.standard.set(account_type_code, forKey: "accountType")
                    router?.nextToPersonalInfoVC()
                }
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            containerView.addSubview(accountView)
            accountView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            accountView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 36).isActive = true
            accountView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            
            if index == 0 {
                accountView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -90 ).isActive = true
            } else if index == 1 {
                accountView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0 ).isActive = true
            } else {
                accountView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 90 ).isActive = true
            }
            
            accountView.layer.shadowColor = UIColor.gray.cgColor
            accountView.layer.shadowOpacity = 0.3
            accountView.layer.shadowOffset = CGSize(width: 2, height: 2)
            accountView.layer.shadowRadius = 6
        }
        
        
        

    }
}
