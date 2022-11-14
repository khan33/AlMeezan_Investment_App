//
//  SubscriptionViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 12/09/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit


enum Switch: Int {
    case fundTrasnfer = 1
    case billPayment = 2
}

class SubscriptionViewController: UIViewController {
    
    private (set) lazy var headerView: PaymentHeaderView = { [unowned self] in
        let view = PaymentHeaderView.init(titleLbl: Headings.subscribe, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var labelView: SubscriptionView = {
        let view = SubscriptionView()
        view.backgroundColor = UIColor.purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var fundTransferView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var billPaymentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fundTransferLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = Headings.fundTransfer
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 18)
        return label
    }()
    
    private let billPaymentLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = Headings.billPayment
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 18)
        return label
    }()
    
    private var innerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("SAVE", for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(transitionToPaymentVC), for: .touchUpInside)
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 20
        return btn
    }()
    
    private var fundSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = true
        switchView.onImage = UIImage(named: "switchOn")
        switchView.offImage = UIImage(named: "switchOff")
        switchView.onTintColor = UIColor.purple
        switchView.tag = 1
        switchView.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    private var billSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = true
        switchView.onImage = UIImage(named: "switchOn")
        switchView.offImage = UIImage(named: "switchOff")
        switchView.onTintColor = UIColor.purple
        switchView.tag = 2
        switchView.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        view.layer.cornerRadius = 10
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .vertical
        view.backgroundColor = UIColor.gray2
        view.spacing = 2
        view.clipsToBounds = true
        view.frame = view.bounds
        return view
    }()
    
    private var agreementView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let disclaimerLbl: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.purple
        label.text = "Disclaimer"
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 14)
        return label
    }()
    
    private let agreementLbl: UILabel = {
        var label = UILabel()
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: Description.agreementDescription)
        attributedString.setColor(color: UIColor.purple, forText: "Terms & Condition")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        label.text = Description.agreementDescription
        label.attributedText = attributedString
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        return label
    }()
    
    
    private let checkBoxBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.isSelected = false
        btn.setImage(UIImage(named: "checkbox"), for: .normal)
        btn.setImage(UIImage(named: "checked"), for: .selected)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(checkBoxStateDidChange), for: .touchUpInside)
        return btn
    }()
    private var cellNumber: TextInputView!
    private var cellNumberTxt: String = ""
    
    var interactor: SubscriptionInteractorProtocol?
    var router: SubscriptionRouterProtocol?
    var customerSubscribe: [SubscriptionEntity.CustomerSubscribed]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        view.addSubview(headerView)
        view.addSubview(saveBtn)
        view.backgroundColor = UIColor.white
        view.addSubview(containerView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(termAndCondition))
        agreementLbl.isUserInteractionEnabled = true
        agreementLbl.addGestureRecognizer(tap)
        containerView.addSubview(innerView)
        innerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(labelView)
        stackView.addArrangedSubview(fundTransferView)
        stackView.addArrangedSubview(billPaymentView)
        fundTransferView.addSubview(fundTransferLbl)
        fundTransferView.addSubview(fundSwitch)
        billPaymentView.addSubview(billPaymentLbl)
        billPaymentView.addSubview(billSwitch)
        agreementView.addSubview(disclaimerLbl)
        agreementView.addSubview(checkBoxBtn)
        agreementView.addSubview(agreementLbl)
        showLoader()
        interactor?.viewDidLoad()
        setupConstraint()
        
        self.agreementLbl.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        tapgesture.numberOfTouchesRequired = 1
        self.agreementLbl.addGestureRecognizer(tapgesture)
        
        
    }
    
    
    func didTapOnterm() {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = TERMS_CONDITIONS
        vc.titleStr = "Terms & Conditions"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.agreementLbl.text else { return }
        let termsCondtion = (text as NSString).range(of: "Terms & Condition")
        if gesture.didTapAttributedTextInLabel(label: self.agreementLbl, inRange: termsCondtion) {
            didTapOnterm()
        }
    }
    @objc func switchStateDidChange(_ sender: UISwitch) {
        if sender.tag == Switch.fundTrasnfer.rawValue {
            if fundSwitch.isOn == true {
                self.customerSubscribe?[1].isActive = true
            } else {
                self.customerSubscribe?[1].isActive = false
            }
        } else {
            if billSwitch.isOn == true {
                self.customerSubscribe?[0].isActive = true
            } else {
                self.customerSubscribe?[0].isActive = false
            }
        }
    }
    
    @objc func checkBoxStateDidChange(_ sender: UIButton) {
        checkBoxBtn.isSelected.toggle()
    }
    
    @objc func termAndCondition(sender: UITapGestureRecognizer) {
        print("tapped.")
    }
    func addPhoneNumber() {
        self.customerSubscribe?[0].mobile = cellNumberTxt
    }
    @objc func transitionToPaymentVC() {
        if !self.cellNumberTxt.isValidMobileNo {
            self.showAlert(title: "Alert", message: "Please enter your valid mobile no.", controller: self) {
            }
        } else if checkBoxBtn.isSelected == false {
            self.showAlert(title: "Alert", message: "Please check the box.", controller: self) {
            }
        } else {
            self.addPhoneNumber()
            self.modalPresentationStyle = .custom
            self.showLoader()
            let request = subcribedRequest(customerSubscribed: self.customerSubscribe)
            interactor?.saveSubscribed(data: request)
            self.dismiss(animated: true)
        }
        
    }
    
    private func setupConstraint() {
        
        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        saveBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        saveBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        saveBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: saveBtn.topAnchor, constant: -20).isActive = true
        
        innerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        innerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        innerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        innerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20).isActive = true
        
        scrollView.centerXAnchor.constraint(equalTo: innerView.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: innerView.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: innerView.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: innerView.bottomAnchor, constant: 0).isActive = true
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        fundTransferLbl.centerYAnchor.constraint(equalTo: fundTransferView.centerYAnchor).isActive = true
        fundTransferLbl.leadingAnchor.constraint(equalTo: fundTransferView.leadingAnchor, constant: 15).isActive = true
        
        fundSwitch.centerYAnchor.constraint(equalTo: fundTransferView.centerYAnchor, constant: 0).isActive = true
        fundSwitch.trailingAnchor.constraint(equalTo: fundTransferView.trailingAnchor, constant: -20).isActive = true
        
        billPaymentLbl.centerYAnchor.constraint(equalTo: billPaymentView.centerYAnchor).isActive = true
        billPaymentLbl.leadingAnchor.constraint(equalTo: billPaymentView.leadingAnchor, constant: 15).isActive = true
        
        billSwitch.centerYAnchor.constraint(equalTo: billPaymentView.centerYAnchor, constant: 0).isActive = true
        billSwitch.trailingAnchor.constraint(equalTo: billPaymentView.trailingAnchor, constant: -20).isActive = true
        
        cellNumber = TextInputView(heading: "Cell Number", placeholder: "Enter your Cell Number", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.cellNumberTxt = enteredText
        }
//        UserDefaults.standard.set(cellNumberTxt, forKey: "Cell Number")
        cellNumber.txtField.keyboardType = .asciiCapableNumberPad
        cellNumber.txtField.isUserInteractionEnabled = false
        cellNumber.setData(text: cellNumberTxt)
        stackView.addArrangedSubview(cellNumber)
        
        
        stackView.addArrangedSubview(agreementView)
        agreementView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        disclaimerLbl.topAnchor.constraint(equalTo: agreementView.topAnchor, constant: 10).isActive = true
        disclaimerLbl.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor, constant: 20).isActive = true
        
        checkBoxBtn.centerYAnchor.constraint(equalTo: agreementView.centerYAnchor, constant: 8).isActive = true
        checkBoxBtn.leadingAnchor.constraint(equalTo: agreementView.leadingAnchor, constant: 20).isActive = true
        
        agreementLbl.topAnchor.constraint(equalTo: disclaimerLbl.topAnchor, constant: 25).isActive = true
        agreementLbl.leadingAnchor.constraint(equalTo: checkBoxBtn.trailingAnchor, constant: 5).isActive = true
        agreementLbl.trailingAnchor.constraint(equalTo: agreementView.trailingAnchor, constant: -10).isActive = true
    }
    
    func updateUI(response: subscriptionResponse) {
        for customer in response.customerSubscribed! {
            if customer.mnemonic == "BILL" {
                self.billPaymentLbl.text = customer.subscription
                self.billSwitch.isOn = customer.isActive ?? false
                self.cellNumber.txtField.text = customer.mobile ?? ""
                self.cellNumberTxt = customer.mobile ?? ""

            } else if customer.mnemonic == "IBFT" {
                self.fundTransferLbl.text = customer.subscription
                self.fundSwitch.isOn = customer.isActive ?? false
            }
        }
    }
    
}
extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
        
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}


class SubscriptionView: UIView {
    
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.purple
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let label: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.text = "Select the service that you would like to subscribe to"
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.addSubview(label)
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraint() {
        
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        self.label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
}



extension SubscriptionViewController: SubscriptionViewProtocol {
    
    
    func subscriptionResponse(_ response: subscriptionResponse) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.customerSubscribe = response.customerSubscribed
            self.updateUI(response: response)
        }
        
    }
    func subcribedResponse(_ response: subcribedResponseModel) {
        DispatchQueue.main.async {
            self.hideLoader()
            print(response)
            if response[0].errID == "00" {
                self.showAlert(title: "Alert", message: "Subscription Submitted Successfully", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showAlert(title: "Alert", message: "Something went worng. Please try again!", controller: self) {
                    
                }
            }
        }
    }
}
