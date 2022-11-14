//
//  Preview3ViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 28/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class Preview3ViewController: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "7 / 9", titleStr: "Preview", subTitle: "Form Details", numberOfPages: 4, currentPageNo: 2, closeAction: {
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
    
    var factaInfo: [PreviewInfo] = [PreviewInfo]()
    var placeOfBirth: [PreviewInfo] = [PreviewInfo]()
    var riskProfileDetails: [PreviewInfo] = [PreviewInfo]()
    var data: SSACNICData?
    override func viewDidLoad() {
        super.viewDidLoad()
        data = Constant.SSA_data
        setupViews()
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let data1 = Constant.setup_data {
            let vc =  QuestionnairePreviewVC(quesitonnaire: data1.fatcaQuestions ?? [], kycDetail: nil, fatca: data?.fatca)
           vc.modalPresentationStyle = .overCurrentContext
           vc.modalTransitionStyle = .crossDissolve
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)

       }
    }
}

extension Preview3ViewController {
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
        
        if let fatctaData = data?.fatca {
            let titleView = PreviewTitleView(heading: "FATCA Details")
            if !titleView.isDescendant(of: stackView1) {
                stackView1.addArrangedSubview(titleView)
            }
            var residenceTaxCountry = fatctaData.countryOfTaxResidence ?? ""
//            if residenceTaxCountry != "USA" && residenceTaxCountry != "NONE" {
//                residenceTaxCountry = "Other Country"
//            }
            factaInfo.append(
                contentsOf: [
                    PreviewInfo(key: "Account Title", value: fatctaData.accountTitle ?? ""),
                    PreviewInfo(key: "Country of Tax Other then Pakistan", value: residenceTaxCountry),
                    PreviewInfo(key: "Questionnaire", value: "View Questionnaire")
                ]
            )
            
            

            for i in 0..<factaInfo.count {
                let view = PreviewView(heading: factaInfo[i].key, value: factaInfo[i].value, isBorderView: false)
                if factaInfo[i].key == "Questionnaire" {
                    view.lblValue.isUserInteractionEnabled = true
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    view.lblValue.addGestureRecognizer(tap)
                }
                stackView1.addArrangedSubview(view)
                
                
            }
        }
        
        if let fatcta_info = data?.fatca {
            let titleView2 = PreviewTitleView(heading: "Place Of Birth")
            if !titleView2.isDescendant(of: stackView2) {
                stackView2.addArrangedSubview(titleView2)
            }
            placeOfBirth.append(
                contentsOf: [
                    PreviewInfo(key: "City", value: fatcta_info.pobCity ?? ""),
                    PreviewInfo(key: "State", value: fatcta_info.pobState ?? ""),
                    PreviewInfo(key: "Country", value: fatcta_info.pobCountry ?? ""),
                ]
            )
            for i in 0..<placeOfBirth.count {
                let view = PreviewView(heading: placeOfBirth[i].key, value: placeOfBirth[i].value, isBorderView: false)
                stackView2.addArrangedSubview(view)
            }
        }
        if let riskProfile = data?.riskProfile {
            let titleView3 = PreviewTitleView(heading: "Risk Profile Details")
            if !titleView3.isDescendant(of: stackView3) {
                stackView3.addArrangedSubview(titleView3)
            }
            
            
            
            riskProfileDetails.append(
                contentsOf: [
                    PreviewInfo(key: "Age", value: riskProfile.age ?? ""),
                    PreviewInfo(key: "Risk-Return Tolerance", value: riskProfile.riskReturn ?? ""),
                    PreviewInfo(key: "Month Saving", value: riskProfile.monthlySavings ?? ""),
                    PreviewInfo(key: "Occupation", value: riskProfile.occupation ?? ""),
                    PreviewInfo(key: "Investment Objective", value: riskProfile.investmentObjective ?? ""),
                    PreviewInfo(key: "Knowledge of Investment", value: riskProfile.knowledgeLevel ?? ""),
                    PreviewInfo(key: "Investment Horizon", value: riskProfile.investmentHorizon ?? ""),
                    PreviewInfo(key: "Ideal Portfolio", value: riskProfile.idealFund ?? ""),
                ]
            )
            
            
            for i in 0..<riskProfileDetails.count {
                let view = PreviewView(heading: riskProfileDetails[i].key, value: riskProfileDetails[i].value, isBorderView: false)
                stackView3.addArrangedSubview(view)
            }
        }
        
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            let vc =  TermsAndConditionsVC()
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
