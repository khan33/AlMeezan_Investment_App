//
//  Preview2ViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 28/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class Preview2ViewController: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "7 / 9", titleStr: "Preview", subTitle: "Form Details", numberOfPages: 4, currentPageNo: 1, closeAction: {
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
        view.spacing = 24
        view.clipsToBounds = true
        return view
    }()
    
    
    
    
    
    
    private (set) lazy var stackView1: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 4
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var stackView2: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 4
        view.clipsToBounds = true
        return view
    }()
    
    
    private (set) lazy var stackView3: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .vertical
        view.spacing = 4
        view.clipsToBounds = true
        return view
    }()
    
    var accountHolderinfo: [PreviewInfo] = [PreviewInfo]()
    var bankAccountInfo: [PreviewInfo] = [PreviewInfo]()
    var nextOfKin: [PreviewInfo] = [PreviewInfo]()
    var kyc_detail: [PreviewInfo] = [PreviewInfo]()

    var data: SSACNICData?
    override func viewDidLoad() {
        super.viewDidLoad()
        data = Constant.SSA_data
        setupViews()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let data1 = Constant.setup_data {
            
            let vc =  QuestionnairePreviewVC(quesitonnaire: data1.pEP ?? [], kycDetail: data?.kyc , fatca: nil)
           vc.modalPresentationStyle = .overCurrentContext
           vc.modalTransitionStyle = .crossDissolve
           UIApplication.topViewController()?.present(vc, animated: true, completion: nil)

       }
    }
}

extension Preview2ViewController {
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
        contentView.layer.cornerRadius = 8
//        contentView.backgroundColor = .white
        contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0).isActive = true
        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true

        if !stackView.isDescendant(of: contentView) {
            contentView.addSubview(stackView)
        }
//        stackView.backgroundColor = .white
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
//        stackView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        stackView1.backgroundColor = .white
        stackView2.backgroundColor = .white
        stackView3.backgroundColor = .white
        stackView.addArrangedSubview(stackView1)
        stackView.addArrangedSubview(stackView2)
        stackView.addArrangedSubview(stackView3)
        
        
        
        if let bankInfo = data?.basicInfo {
            let titleView2 = PreviewTitleView(heading: "Bank Account Details")
            bankAccountInfo.append(
                contentsOf: [
                    PreviewInfo(key: "Bank Name", value: bankInfo.bankName ?? ""),
                    PreviewInfo(key: "Account Number", value: bankInfo.bankAccountNo ?? ""),
                    PreviewInfo(key: "Branch Name", value: bankInfo.branchName ?? ""),
                    PreviewInfo(key: "Branch City", value: bankInfo.branchCity ?? ""),
                ]
            )
            
            if !titleView2.isDescendant(of: stackView2) {
                stackView2.addArrangedSubview(titleView2)
            }
            
            
            for i in 0..<bankAccountInfo.count {
                let view = PreviewView(heading: bankAccountInfo[i].key, value: bankAccountInfo[i].value, isBorderView: false)
                stackView2.addArrangedSubview(view)
            }
        }
        
        if data?.basicInfo?.jointHolder?.fullName != "" && data?.basicInfo?.jointHolder?.nic != "" {
            var cnicExpiry = data?.basicInfo?.jointHolder?.expiryDate ?? ""
            if data?.basicInfo?.jointHolder?.expiryDate == "2100-01-01" {
                cnicExpiry = "Lifetime validity"
            }
            if let acountHolderInfo = data?.basicInfo?.jointHolder {
                let titleView = PreviewTitleView(heading: "Joint Account Holder Details")
                
                if !titleView.isDescendant(of: stackView1) {
                    stackView1.addArrangedSubview(titleView)
                }
                accountHolderinfo.append(
                    contentsOf: [
                        PreviewInfo(key: "Full Name", value: acountHolderInfo.fullName ?? ""),
                        PreviewInfo(key: "Relationship with Customer", value: acountHolderInfo.relationship ?? ""),
                        PreviewInfo(key: "CNIC", value: acountHolderInfo.cnic ?? ""),
                        PreviewInfo(key: "CNIC Issue Date", value: acountHolderInfo.issueDate ?? ""),
                        PreviewInfo(key: "CNIC Expiry Date", value: cnicExpiry),
                    ]
                )

                for i in 0..<accountHolderinfo.count {
                    let view = PreviewView(heading: accountHolderinfo[i].key, value: accountHolderinfo[i].value, isBorderView: false)
                    stackView1.addArrangedSubview(view)
                }
            }
        } else {
            if let nextOfKinData = data?.basicInfo?.nextOfKin {
                let titleView3 = PreviewTitleView(heading: "Next of KIN")
                nextOfKin.append(
                    contentsOf: [
                        PreviewInfo(key: "Full Name", value: nextOfKinData.fullName ?? ""),
                        PreviewInfo(key: "Contact Number", value: nextOfKinData.contactNumber ?? ""),
                        PreviewInfo(key: "Relationship with customer", value: nextOfKinData.relationship ?? ""),
                        PreviewInfo(key: "Address", value: nextOfKinData.address ?? ""),
                    ]
                )
                if !titleView3.isDescendant(of: stackView3) {
                    stackView3.addArrangedSubview(titleView3)
                }
                for i in 0..<nextOfKin.count {
                    let view = PreviewView(heading: nextOfKin[i].key, value: nextOfKin[i].value, isBorderView: false)
                    stackView3.addArrangedSubview(view)
                }
            }
        }
        
        if let kycDetail = data?.kyc {
            let titleView4 = PreviewTitleView(heading: "KYC")
            
            
            
            kyc_detail.append(
                contentsOf: [
                    PreviewInfo(key: "Source Of Income", value: kycDetail.sourceOfIncome ?? ""),
                    PreviewInfo(key: "Source Of Wealth", value: kycDetail.sourceOfWealth ?? ""),
                    PreviewInfo(key: "Where Did You Hear About Us?", value: kycDetail.whereDidYouHearAboutUs ?? ""),
                    
                    
                    PreviewInfo(key: "Possible Mode of Transaction", value: kycDetail.modeOfTransaction ?? ""),
                    PreviewInfo(key: AppString.Heading.numbeerOfTransaction, value: kycDetail.numberOfTransaction ?? ""),
                    PreviewInfo(key: "Expected Turnover In Account", value: kycDetail.expectedTurnOverMonthlyAnnual ?? ""),
                    PreviewInfo(key: AppString.Heading.expectedAmount, value: kycDetail.expectedTurnOver ?? ""),
                    PreviewInfo(key: "Questionnaire", value: "View Questionnaire")
                ]
            )
            
            if kycDetail.daoID != "90" {
                let p = PreviewInfo(key: "Sale Person ID", value: kycDetail.daoID ?? "")
                kyc_detail.insert(p, at: 3)
            }
            if !titleView4.isDescendant(of: stackView3) {
                stackView3.addArrangedSubview(titleView4)
            }
            
            for i in 0..<kyc_detail.count {
                let view = PreviewView(heading: kyc_detail[i].key, value: kyc_detail[i].value, isBorderView: false)
                if kyc_detail[i].key == "Questionnaire" {
                    view.lblValue.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    view.lblValue.addGestureRecognizer(tap)
                }
                stackView3.addArrangedSubview(view)
            }
        }
        
        
        
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            let vc =  Preview3ViewController()
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
    
    
//    let storyboard = UIStoryboard(name: "Home", bundle: nil)
//    let vc = storyboard.instantiateViewController(withIdentifier: "VisitDateCalanderVC") as? VisitDateCalanderVC
//    
//    if #available(iOS 10.0, *) {
//        vc?.modalPresentationStyle = .overCurrentContext
//    } else {
//        vc?.modalPresentationStyle = .currentContext
//    }
//    vc?.providesPresentationContextTransitionStyle = true
//    //vc?.delegate = self
//    present(vc!, animated: true, completion: {() -> Void in
//    })
    
    
}
