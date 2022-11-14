//
//  TermsAndConditionsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 30/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "7 / 9", titleStr: "Preview", subTitle: "Terms and Conditions", numberOfPages: 4, currentPageNo: 3, closeAction: {
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
    
    var isTerms: Bool = false
    var isTerms1: Bool = false
    var isTerms2: Bool = false
    var isTerms3: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

}
extension TermsAndConditionsVC {
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
//        contentView.backgroundColor = .white
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
        
        let termsAndConditionView1 = TermsAndConditionView(heading: "I hereby confirm that all information provided in the form is true and correct to the best of my knowledge. I agree that I shall assume sole responsibility for determining the merits or suitability of any and all advice and /or recommendations of Al Meezan before relying on the same to enter into any transaction. I will not hold Al Meezan responsible for any loss which may occur as a result of my decision. I further confirm that I have read the Trust Deeds, Offering Documents, Supplemental Trust Deeds and Supplemental Offering Documents that govern these Investment transactions. I understand the features and risks of the product in which I am investing. I also confirm having the knowledge of applicable load percentages, transaction cost, price adjustment charges and government taxes where applied.", selectedCheckboxCloser: { isSelect in
            self.isTerms = isSelect
        })
        termsAndConditionView1.layer.cornerRadius = 8
        stackView.addArrangedSubview(termsAndConditionView1)
        
        
        let termsAndConditionView2 = TermsAndConditionView(heading: "The provided source of income/ fund, wealth and profession details are genuine / authentic and true to the best of my knowledge.", selectedCheckboxCloser: { isSelect in
            self.isTerms1 = isSelect
        })
        termsAndConditionView2.layer.cornerRadius = 8
        stackView.addArrangedSubview(termsAndConditionView2)
        
        
        
        let termsAndConditionView3 = TermsAndConditionView(heading: "I declare to have understood and completed this entire Risk/ Return Profiling Questionnaire. I understand and agree that I can invest in any other fund category as per my discretion.", selectedCheckboxCloser: { isSelect in
            self.isTerms2 = isSelect
        })
        termsAndConditionView3.layer.cornerRadius = 8
        stackView.addArrangedSubview(termsAndConditionView3)
        
        
        
        let termsAndConditionView4 = TermsAndConditionView(heading: "I do hereby confirm that the investment being made is solely my own funds and that the funds beneficially owned by other person(s) will not be used.", selectedCheckboxCloser: { isSelect in
            self.isTerms3 = isSelect
        })
        termsAndConditionView4.layer.cornerRadius = 8
        stackView.addArrangedSubview(termsAndConditionView4)
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            if self.isTerms == false {
                self.showAlert(title: "Alert", message: "Please Check Terms and Conditions.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            else if self.isTerms1 == false {
                self.showAlert(title: "Alert", message: "Please Check Terms and Conditions.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            else if self.isTerms2 == false {
                self.showAlert(title: "Alert", message: "Please Check Terms and Conditions.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            else if self.isTerms3 == false {
                self.showAlert(title: "Alert", message: "Please Check Terms and Conditions.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            } else {
                let accountType = UserDefaults.standard.string(forKey: "accountType") ?? "BOTH"
                if accountType == "VPS" {
                    let vc = ThankYouViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc =  InvestmentdetailsViewController()
                    InvestmentConfigurator.configureModule(viewController: vc)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
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
