//
//  AddPayeeOTPViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 26/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit
import SVPinView

enum PaymentService {
    case fundTransfer
    case billPayement
}


class AddPayeeOTPViewController: UIViewController {

    
    
    //MARK: Properties
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: "Add Beneficiary", closeAction: {
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
        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .asciiCapableNumberPad
        pinView.keyboardAppearance = .default
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
    
    var unique_id: String
    var payee: FundTransferEntity.FetchPayeeTitleResponseModel?
    var type: PaymentService
    var fundTransfer_request: FundTransferEntity.AddPayeeRequest?
    var billPayemnt_request: BillInquiryEntity.BillInquiryRequest?
    init(payee: FundTransferEntity.FetchPayeeTitleResponseModel?, unique_id : String, type: PaymentService, transferReq: FundTransferEntity.AddPayeeRequest?, billReq: BillInquiryEntity.BillInquiryRequest?) {
        self.unique_id = unique_id
        self.payee = payee
        self.type = type
        self.fundTransfer_request = transferReq
        self.billPayemnt_request = billReq
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var interactor: PayeeOTPInteractorProtocol?
    var router: PayeeOTPRouterProtocol?
    var pinCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = self.navigationController
        setupViews()
        
        otpView.didFinishCallback = { [weak self] pin in
            self?.pinCode = pin
            self?.showLoader()
            if self?.type == .fundTransfer {
                let reqeust  = FundTransferEntity.OTPVerificationRequest(Otp: self?.pinCode, uniqueId: self?.unique_id)
                self?.interactor?.otpVerify(reqeust)
            } else {
                
            }
        }

    }
    
    @objc private
    func didTapOnResendBtn(_ sender: UIButton) {
        if type == .fundTransfer {
            self.showLoader()
            if let req = fundTransfer_request {
                interactor?.addPayee(req)
            }
        } else {
            if let req = billPayemnt_request {
                interactor?.loadBillInquiry(request: req)
            }
        }
    }
    
}
extension AddPayeeOTPViewController {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        
        
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        
        if !imgView.isDescendant(of: containerView) {
            containerView.addSubview(imgView)
        }
        
        
        if !lblTitle.isDescendant(of: containerView) {
            containerView.addSubview(lblTitle)
        }
        
        if !otpView.isDescendant(of: containerView) {
            containerView.addSubview(otpView)
        }
        
        
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
            
            
            imgView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            
            
            lblTitle.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 44),
            lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            
            otpView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            otpView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            otpView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 24),
            otpView.heightAnchor.constraint(equalToConstant: 60),
            
            
        ])
        
        let btnView = CenterButtonView.init(title: AppString.Heading.veriftyOTPBtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            self.showLoader()
            let reqeust  = FundTransferEntity.OTPVerificationRequest(Otp: self.pinCode, uniqueId: self.unique_id)
            self.interactor?.otpVerify(reqeust)
            
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


extension AddPayeeOTPViewController: PayeeOTPViewProtocol {
    func otpVerificationSuccess(_ response: otpVerifcationResponse) {
        if response.count > 0 {
            DispatchQueue.main.async {
                self.hideLoader()
                if response[0].ErrID == "00" {
                    // success
                    let vc = AddPayeeSuccessVC(payee: self.payee)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    self.showAlert(title: "Alert", message: response[0].ErrMsg ?? "Invalid OTP Entered. Please try it again!" , controller: self) {
                    }
                    return
                }
            }
        }
    }
    
    func addPayee(_ response: [FundTransferEntity.AddPayeeResponseModel]) {
        if response.count > 0 {
            DispatchQueue.main.async {
                self.hideLoader()
                self.showAlert(title: "Alert", message: "OTP resend to your mobile number", controller: self) {
                    
                }
            }
        }
    }
    
    func successBillInquiry(response: [BillInquiryEntity.BillInquiryResponse]) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.showAlert(title: "Alert", message: "OTP resend to your mobile number", controller: self) {
                
            }
        }
    }


}
