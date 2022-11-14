//
//  PreviewBasicInfoVC.swift
//  AlMeezan
//
//  Created by Atta khan on 28/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class PreviewBasicInfoVC: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "7 / 9", titleStr: "Preview", subTitle: "Form Details", numberOfPages: 4, currentPageNo: 0, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        //view.backgroundColor = .white
        return view
    }()
    
    private (set) lazy var scrollView: UIScrollView = { [unowned self] in
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var contentView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var stackView: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 4
        view.clipsToBounds = true
        return view
    }()
    
    
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 112, green: 31, blue: 126, alpha: 1)
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        label.text = "Customer Details"
        return label
    }()
    
    private (set) lazy var bottomLine: UIView = { [unowned self] in
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.1)
        return view
    }()
    
    private (set) lazy var topView: UIView = { [unowned self] in
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    
    var data: SSACNICData?
    var info: [PreviewInfo] = [PreviewInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        data = Constant.SSA_data
        setupViews()
    }
}


extension PreviewBasicInfoVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = UIColor.rgb(red: 242, green: 244, blue: 248, alpha: 1)
        
        
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
        

        if !scrollView.isDescendant(of: containerView) {
            containerView.addSubview(scrollView)
        }

        scrollView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
       // scrollView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16).isActive = true

        if !contentView.isDescendant(of: scrollView) {
            scrollView.addSubview(contentView)
        }
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true

        if !stackView.isDescendant(of: contentView) {
            contentView.addSubview(stackView)
        }

        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        
        
        let titleView = PreviewTitleView(heading: "Customer Details")
        
        if !titleView.isDescendant(of: stackView) {
            stackView.addArrangedSubview(titleView)
        }
        
        
        
        
        if let basicInfo = data?.basicInfo {
            var cnicExpiry = basicInfo.cnicExpiryDate ?? ""
            if basicInfo.cnicExpiryDate == "2100-01-01" {
                cnicExpiry = "Lifetime validity"
            }
            var zakatStatus = basicInfo.zakatStatus ?? "N"
            if basicInfo.religion != "Non-Muslim" {
                zakatStatus = "Y"
            }
            info.append(
                contentsOf: [
                    PreviewInfo(key: "Account Type", value: basicInfo.accountType ?? ""),
                    PreviewInfo(key: "CNIC/NICOP", value: basicInfo.cnic ?? ""),
                    PreviewInfo(key: "Customer Name", value: basicInfo.fullName ?? ""),
                    PreviewInfo(key: AppString.Heading.fName, value: basicInfo.fatherHusbandName ?? ""),
                    PreviewInfo(key: AppString.Heading.mName, value: basicInfo.motherMaidenName ?? ""),
                    PreviewInfo(key: "Date Of Birth", value: basicInfo.dateOfBirth ?? ""),
                    PreviewInfo(key: "Marital status", value: basicInfo.maritalStatus ?? ""),
                    PreviewInfo(key: "CNIC Issue Date", value: basicInfo.cnicIssueDate ?? ""),
                    PreviewInfo(key: AppString.Heading.cnicExpiry, value: cnicExpiry),
                    PreviewInfo(key: "Nationality", value: basicInfo.nationality ?? ""),
                    PreviewInfo(key: "Dual Nationality", value: basicInfo.dualNational ?? ""),
                    PreviewInfo(key: "Residential Status", value: basicInfo.residentialStatus ?? ""),
                    PreviewInfo(key: "Religion", value: basicInfo.religion ?? ""),
                    PreviewInfo(key: "Zakat Exemption", value: zakatStatus == "Y" ? "YES" : "NO" ),
                    PreviewInfo(key: "Mobile Number", value: basicInfo.mobileNo ?? ""),
                    PreviewInfo(key: "Email Address", value: basicInfo.emailAddress ?? ""),
                    PreviewInfo(key: "Dividend Mandate", value: basicInfo.cashDividend ?? ""),
                    PreviewInfo(key: "Stock Dividend", value: basicInfo.stockDividend ?? ""),
                    PreviewInfo(key: "Current Address", value: basicInfo.currentAddress ?? ""),
                    PreviewInfo(key: "Current City", value: basicInfo.currentCity ?? ""),
                    PreviewInfo(key: "Current Address Country", value: basicInfo.currentCountry ?? ""),
                    PreviewInfo(key: "Permanent Address", value: basicInfo.permanentAddress ?? ""),
                    PreviewInfo(key: "Permanent City", value: basicInfo.permanentCity ?? ""),
                    PreviewInfo(key: "Permanent Address Country", value: basicInfo.permanentCountry ?? ""),
                ]
            )
        }
        for i in 0..<info.count {
            let view = PreviewView(heading: info[i].key, value: info[i].value, isBorderView: false)
            stackView.addArrangedSubview(view)
        }
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            let vc =  Preview2ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        btnView.containerView.backgroundColor = UIColor.rgb(red: 242, green: 244, blue: 248, alpha: 1)
        btnView.translatesAutoresizingMaskIntoConstraints = false
        btnView.clipsToBounds = true
        if !btnView.isDescendant(of: containerView) {
            containerView.addSubview(btnView)
        }
        btnView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        btnView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        btnView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        btnView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
}

struct PreviewInfo {
    var key: String
    var value: String
}
