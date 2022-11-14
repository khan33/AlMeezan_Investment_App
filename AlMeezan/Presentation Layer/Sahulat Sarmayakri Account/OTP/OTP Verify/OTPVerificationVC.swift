//
//  OTPVerificationVC.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
import SVPinView

class OTPVerificationVC: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "1 / 9", titleStr: AppString.Heading.SSA, subTitle: AppString.Heading.otp, numberOfPages: 0, currentPageNo: 0 ,  closeAction: {
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
    
    private (set) lazy var imgView: UIImageView = { [unowned self] in
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "otpPhone")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppString.Heading.enterOTP
        label.textColor =  UIColor.rgb(red: 35, green: 39, blue: 70, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 18)
        return label
    }()
    
    
    private (set) lazy var otpView: SVPinView = { [unowned self] in
        let pinView = SVPinView()
        pinView.translatesAutoresizingMaskIntoConstraints = false
        pinView.clipsToBounds = true
        pinView.pinLength = 4
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 24
        pinView.cornerRadius  = 4
        pinView.textColor = UIColor.black
        pinView.shouldSecureText = true
        pinView.style = .box
        pinView.activeFieldCornerRadius = 4
        pinView.borderLineColor = UIColor.rgb(red: 185, green: 187, blue: 198, alpha: 1)
        pinView.activeBorderLineColor = UIColor.rgb(red: 185, green: 187, blue: 198, alpha: 1)
//        pinView.borderLineThickness = 1
//        pinView.activeBorderLineThickness = 3

        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .asciiCapableNumberPad
        pinView.keyboardAppearance = .default
        //pinView.pinIinputAccessoryView = UIView()
        //pinView.placeholder = "******"
        pinView.becomeFirstResponderAtIndex = 0

        return pinView
    }()
    
    private (set) lazy var lblOTPNotReceived: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppString.Heading.notReceivedCode
        label.textColor =  UIColor.rgb(red: 80, green: 109, blue: 133, alpha: 1)
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 14)
        return label
    }()
    
    private (set) lazy var resendBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle(AppString.Heading.resendOTP, for: .normal)
        btn.setTitleColor(UIColor.themeColor, for: .normal)
        btn.titleLabel?.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        btn.addTarget(self, action: #selector(didTapOnResendBtn), for: .touchUpInside)
        return btn
    }()
    
    
    
    var interactor: OTPVerificationInteractorProtocol?
    var router: OTPVerificationRouterProtocol?
    var pinCode: String = ""
    var customerInfo: CustomerInfo
    init(info: CustomerInfo) {
        self.customerInfo = info
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        setupViews()
        if let chanel = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            if chanel == "SSA" {
                headerView.lblTitle.text = AppString.Heading.SSA
            } else {
                headerView.lblTitle.text = "Digital Account"
            }
        }
        
        otpView.didFinishCallback = { [weak self] pin in
            self?.pinCode = pin
            self?.showLoader()
            self?.interactor?.verifyPinCode(code: self?.pinCode)
        }
    }
    
    @objc private
    func didTapOnResendBtn(_ sender: UIButton) {
        showLoader()
        self.interactor?.resendOTP(info: customerInfo)
    }
}

extension OTPVerificationVC: OTPVerificationViewProtocol {
    func isErrorMessage(withMessage message: String) {
        hideLoader()
        showAlert(title: "Alert", message: message, controller: self) {
            self.pinCode = ""
            self.otpView.clearPin()
        }
    }
    func OTPVerifcationSuccessData(response: OTPVerificationEntity.OTPVerificationResponseModel) {
        hideLoader()
        
        if response.accountType?.count ?? 0 > 0 {
            router?.nextToAccountTypeVC()
        } else {
            self.showAlert(title: "Alert", message: "Your desired CNIC No. is already registered.", controller: self) {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
    }
    func OTPEmptyField () {
        hideLoader()
    }
    func successfullyOTPSend() {
        DispatchQueue.main.async {
            self.hideLoader()
        }
    }
}


extension OTPVerificationVC {
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
        if !imgView.isDescendant(of: containerView) {
            containerView.addSubview(imgView)
        }
        
        imgView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24).isActive = true
        
        
        if !lblTitle.isDescendant(of: containerView) {
            containerView.addSubview(lblTitle)
        }
        
        lblTitle.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 44).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        
        if !otpView.isDescendant(of: containerView) {
            containerView.addSubview(otpView)
        }
        
        otpView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        otpView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        otpView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 24).isActive = true
        otpView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.veriftyOTPBtn) { [weak self] (clicked) in
            guard let self = self else {return}
            self.showLoader()
            self.interactor?.verifyPinCode(code: self.pinCode)
        }
        
        btnView.translatesAutoresizingMaskIntoConstraints = false
        btnView.clipsToBounds = true
        if !btnView.isDescendant(of: containerView) {
            containerView.addSubview(btnView)
        }
        
        btnView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        btnView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        btnView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16).isActive = true
        
        if !resendBtn.isDescendant(of: containerView) {
            containerView.addSubview(resendBtn)
        }
        resendBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        resendBtn.bottomAnchor.constraint(equalTo: btnView.topAnchor, constant: -6).isActive = true
        
        
        if !lblOTPNotReceived.isDescendant(of: containerView) {
            containerView.addSubview(lblOTPNotReceived)
        }
        lblOTPNotReceived.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        lblOTPNotReceived.bottomAnchor.constraint(equalTo: resendBtn.topAnchor, constant: -6).isActive = true
        
        
    }
}
