//
//  OTPViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
import Toast

class OTPViewController: UIViewController {
    // MARK: VIEW PROPERTIES
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "1 / 9", titleStr: AppString.Heading.SSA, subTitle: AppString.Heading.basicInfo, numberOfPages: 0, currentPageNo: 0, closeAction: {
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
        view.backgroundColor = .white
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
        view.spacing = 16
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var blurView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var popupView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        return view
    }()
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor =  UIColor.black
        label.font = UIFont(name: AppFontName.robotoMedium, size: 16)
        return label
    }()
    private (set) lazy var descLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "Sahulat Sarmayakari Account"
        label.numberOfLines = 0
        label.font = UIFont(name: AppFontName.robotoRegular, size: 15)
        return label
    }()
    
    private (set) lazy var acknowledgeBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("ACKNOWLEDGED", for: .normal)
        btn.setTitleColor(UIColor.init(rgb: 0x8A269B), for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(removeBlurView), for: .touchUpInside)
        return btn
    }()
    
    
    var interactor: OTPViewControllerInteractorProtocol?
    var router: OTPViewControllerRouterProtocol?
    var simOwner: [OptionModel] = [OptionModel]()
    private var cnicTxt: String     =   ""
    private var phoneTxt: String    =   ""
    private var emailTxt: String    =   ""
    private var simOwnerTxt: String =   ""
    private var simOwnerCodeTxt: String =   ""
    private var simOwnerCNICTxt: String = ""
    
    var dataSource: GenericPickerDataSource<OptionModel>?
    var simOwnerView: ButtonPickerView?
    var CNICView: TextInputView!
    var mobileView: TextInputView!
    var simOwnerCNICView: TextInputView!
    var popupHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        showLoader()
        interactor?.loadData()
        
        setupViews()
        if let chanel = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            if chanel == "SSA" {
                lblTitle.text = "Sahulat Sarmayakari Account"
                headerView.lblTitle.text = AppString.Heading.SSA
                descLbl.text = "\u{2022} Basic Investment Account with the option to invest in Mutual Funds and Voluntary Pension Scheme. \n\u{2022} Maximum Investment amount: \nRs.\u{00a0}1,000,000 at any point from the date of account opening. \n\u{2022} Maximum Investment limit is Rs.\u{00a0}800,000. \n\u{2022} Single Investment amount should not exceed Rs.\u{00a0}400,000."
                
            } else {
                lblTitle.text = "Digital Account"
                headerView.lblTitle.text = "Digital Account"
                
                descLbl.text = "\u{2022} Open a full-fledged investment account digitally with access to all funds, and no limit on investment amount at any point. \n\u{2022} Documents would be required to upload during the process."
            }
        }
        self.blurView.isHidden = false
        self.popupView.isHidden = false
        
    }
    
    @objc func removeBlurView() {
        self.blurView.isHidden = true
        self.popupView.isHidden = true
    }
    
    private func showDocumentPopup(_ txt: String) {
        self.blurView.isHidden = false
        self.popupView.isHidden = false
        lblTitle.text = "REQUIRED DOCUMENTS"
        acknowledgeBtn.setTitle("OK", for: .normal)
        descLbl.text = txt
        popupHeight.constant = 200.0
        self.view.layoutIfNeeded()
    }
}

extension OTPViewController: OTPViewControllerViewProtocol {
    func setupDataSuccess(data: SetupModel?) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.simOwnerView?.txtField.isUserInteractionEnabled = true
            self.simOwner = data?.simOwner ?? []
//            if self.simOwner.count > 0 {
//                self.simOwnerCodeTxt = self.simOwner[0].code ?? ""
//                self.simOwnerTxt = self.simOwner[0].name ?? ""
//                self.simOwnerView?.setData(text: self.simOwnerTxt)
//            }
        }
       
    }
    func setupDataFailure() {
        hideLoader()
    }
    func isErrorMessage(withMessage message: String) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.showAlert(title: "Alert", message: message, controller: self) {
            }
        }
    }

    
    func successfullyOTPSend() {
        DispatchQueue.main.async {
            self.hideLoader()
            let data = CustomerInfo(CNIC: self.cnicTxt, email: self.emailTxt, mobileNO: self.phoneTxt, simOwner: self.simOwnerTxt, simOwnerCode: self.simOwnerCodeTxt)
            
            self.router?.nextOTPView(data: data)
        }
    }
    
    func hasServerError(message: String) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.showAlert(title: "Alert", message: message, controller: self) {
            }
        }
    }
}

extension OTPViewController {
    fileprivate func setupViews() {
//
//        cnicTxt = "1234567890457"
//        phoneTxt = "03200428778"
//        emailTxt = "test@gmail.com"
//        simOwnerCodeTxt = "SELF"

        
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
        

        if !scrollView.isDescendant(of: containerView) {
            containerView.addSubview(scrollView)
        }

        scrollView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        

        if !contentView.isDescendant(of: scrollView) {
            scrollView.addSubview(contentView)
        }

        contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true

        contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true

        contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true

        if !stackView.isDescendant(of: contentView) {
            contentView.addSubview(stackView)
        }

        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        
        CNICView = TextInputView(heading:  AppString.Heading.cnic, placeholder: AppString.PlaceHoderText.enterCNIC, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.cnicTxt = enteredText
        }
        UserDefaults.standard.set(cnicTxt, forKey: "CNIC")
        CNICView.txtField.keyboardType = .asciiCapableNumberPad
        CNICView.setData(text: cnicTxt)
        stackView.addArrangedSubview(CNICView)

        mobileView = TextInputView(heading:  AppString.Heading.mobileNumber, placeholder: "923XXXXXXXXX", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.phoneTxt = enteredText
        }
        mobileView.setData(text: phoneTxt)
        mobileView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(mobileView)

        let emailView = TextInputView(heading:  AppString.Heading.email, placeholder: AppString.PlaceHoderText.enterEmail, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.emailTxt = enteredText
        }
        emailView.setData(text: emailTxt)
        emailView.txtField.keyboardType = .emailAddress
        emailView.txtField.autocapitalizationType = .allCharacters
        stackView.addArrangedSubview(emailView)
        
        simOwnerCNICView = TextInputView(heading:  AppString.Heading.cnicMobileOwner, placeholder: "Enter only numbers", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.simOwnerCNICTxt = enteredText
        }
        simOwnerCNICView.txtField.keyboardType = .asciiCapableNumberPad
        simOwnerCNICView.isHidden = true
        
        simOwnerView?.txtField.isUserInteractionEnabled = false
        simOwnerView = ButtonPickerView(heading:  AppString.Heading.ownership, placeholder: AppString.PlaceHoderText.selectOwnership, image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.simOwner,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: 0, didSelect: { (data) in
                            self.simOwnerView?.txtField.text = data.name
                            self.simOwnerCodeTxt = data.code ?? ""
                            self.simOwnerTxt = data.name ?? ""
                            self.simOwnerCNICView.isHidden = true
                            if self.simOwnerCodeTxt == "Relative" {
                                self.simOwnerCNICView.isHidden = false
                                self.showDocumentPopup(RequiredDocumet.relative_family.rawValue)
                            } else if self.simOwnerCodeTxt == "Company" {
                                self.showDocumentPopup(RequiredDocumet.company.rawValue)
                            } else if self.simOwnerCodeTxt == "Intl" {
                                self.showDocumentPopup(RequiredDocumet.intl.rawValue)
                            }
                            
                        }
            )
            self.simOwnerView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        simOwnerView?.txtField.isUserInteractionEnabled = false
        simOwnerView?.setData(text: simOwnerTxt)
        stackView.addArrangedSubview(simOwnerView!)
        
        
       
        stackView.addArrangedSubview(simOwnerCNICView)
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            if self.cnicTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your CNIC.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.cnicTxt.count < 13 {
                self.showAlert(title: "Alert", message: "Enter valid CNIC Number", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }

            if self.phoneTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your mobile number.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if !self.phoneTxt.isValidMobileNo {
                self.showAlert(title: "Alert", message: "Please enter your valid mobile no.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            let firstIndex = self.phoneTxt.first
            if firstIndex == "9" {
                if self.phoneTxt.count < 12 {
                    self.showAlert(title: "Alert", message: "Please enter your valid mobile no.", controller: self) {
                        //self.nameView.txt.becomeFirstResponder()
                    }
                    return
                }
            }

            if self.emailTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your email.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
                if !self.emailTxt.isValidEmail {
                self.showAlert(title: "Alert", message: "Please enter your valid email.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }

            if self.simOwnerCodeTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your ownership of mobile number.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            UserDefaults.standard.set(self.simOwnerCodeTxt, forKey: "SimOwner_Code")


            if self.simOwnerCodeTxt == "Relative" {
                if self.simOwnerCNICTxt == "" {
                    self.showAlert(title: "Alert", message: "Please enter CNIC of your ownership of mobile number.", controller: self) {

                    }
                    return
                }
                if self.simOwnerCNICTxt.count < 13 {
                    self.showAlert(title: "Alert", message: "Enter valid ownership CNIC", controller: self) {
                        //self.nameView.txt.becomeFirstResponder()
                    }
                    return
                }
                UserDefaults.standard.set(self.simOwnerCNICTxt, forKey: "SimOwnerCNIC")
            }


            UserDefaults.standard.set(self.cnicTxt, forKey: "CNIC")
            UserDefaults.standard.set(self.emailTxt, forKey: "EmailAddress")

            UserDefaults.standard.set(self.phoneTxt, forKey: "phone_number")
            self.showLoader()
            self.interactor?.didTapOnContinueBtn(cnic: self.cnicTxt, phone: self.phoneTxt, email: self.emailTxt, simOwnerTxt: self.simOwnerTxt, simOwnerCode: self.simOwnerCodeTxt)
            
            
//            let vc = PersonalInfoVC()
//            PersonalInfoConfigurator.configureModule(viewController: vc)
//            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
//            let info = PersonalInfoEntity.BasicInfo(fullName: nil, fatherHusbandName: nil, motherMaidenName: nil, cnicIssueDate: nil, cnicExpiryDate: nil, dateOfBirth: nil, maritalStatus: nil, religion: nil, nationality: nil, dualNational: nil, residentialStatus: nil, phoneNo: nil, officeNo: nil, mobileNo: nil, mobileNetwork: nil, ported: nil, emailAddress: nil, currentAddress: nil, currentCity: nil, currentCountry: nil, permanentAddress: nil, permanentCity: nil, permanentCountry: nil, bankName: nil, bankAccountNo: nil, branchName: nil, branchCity: nil, cashDividend: nil, stockDividend: nil, nextOfKin: nil, jointHolder: nil, simOwner: nil, daoID: nil, cnic: nil, accountType: nil, channel: "SSA")
//            let vc = PrincipalAccountVC(basicInfo: info)
//            PrincipalAccountConfigurator.configureModule(viewController: vc)
//            self.navigationController?.pushViewController(vc, animated: false)
         
        }
        
        btnView.translatesAutoresizingMaskIntoConstraints = false
        btnView.clipsToBounds = true
        if !btnView.isDescendant(of: containerView) {
            containerView.addSubview(btnView)
        }
        btnView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        btnView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        btnView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        btnView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        
        blurView.backgroundColor = .black.withAlphaComponent(0.69999999)
        blurView.isOpaque = false
        if !blurView.isDescendant(of: self.view) {
            self.view.addSubview(blurView)
        }
        blurView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        if !popupView.isDescendant(of: self.view) {
            self.view.addSubview(popupView)
        }
        
        popupView.backgroundColor = .white
        popupView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor, constant: 0).isActive = true
        popupView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor, constant: 0).isActive = true
        popupView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 20).isActive = true
//        popupHeight = popupView.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 0.4)
//        popupHeight.isActive = true

        let constant = self.view.bounds.size.height / 3
        popupHeight = popupView.heightAnchor.constraint(equalToConstant: constant)
        popupHeight.isActive = true
                 
        
        if !lblTitle.isDescendant(of: self.popupView) {
            self.popupView.addSubview(lblTitle)
        }
        
        lblTitle.leadingAnchor.constraint(equalTo: self.popupView.leadingAnchor, constant: 16).isActive = true
        lblTitle.topAnchor.constraint(equalTo: self.popupView.topAnchor, constant: 16).isActive = true
        
        if !descLbl.isDescendant(of: self.popupView) {
            self.popupView.addSubview(descLbl)
        }
        
        descLbl.leadingAnchor.constraint(equalTo: self.popupView.leadingAnchor, constant: 16).isActive = true
        descLbl.topAnchor.constraint(equalTo: self.lblTitle.bottomAnchor, constant: 16).isActive = true
        
        descLbl.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -16).isActive = true
        
        
        if !acknowledgeBtn.isDescendant(of: self.popupView) {
            self.popupView.addSubview(acknowledgeBtn)
        }
        
       acknowledgeBtn.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -16).isActive = true
        acknowledgeBtn.bottomAnchor.constraint(equalTo: self.popupView.bottomAnchor, constant: -16).isActive = true
    }
    
    
    
    
    
}


enum RequiredDocumet: String {
    case relative_family = "\u{2022} CNIC Front \n\u{2022} CNIC Back. \n\u{2022} Affidavit is Required"
    case company = "\u{2022} Company Authorization letter \n\u{2022} Mobile Bill"
    case intl = "\u{2022} Mobile Document/Copy of Bill is Required"
}
