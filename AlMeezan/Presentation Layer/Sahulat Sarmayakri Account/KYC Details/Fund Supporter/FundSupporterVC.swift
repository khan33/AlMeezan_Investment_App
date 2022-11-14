//
//  FundSupporterVC.swift
//  AlMeezan
//
//  Created by Atta khan on 08/06/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit
import DatePickerDialog

class FundSupporterVC: UIViewController {
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.alpha = 0.9999999
        return view
    }()
    
    
    
    private (set) lazy var popupView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
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
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 91, green: 95, blue: 120, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 13)
        label.text = "FUND PROVIDER DETAILS(IF OTHER THAN PRINCIPAL ACCOUNT HOLDER)"
        label.numberOfLines = 0
        return label
    }()
    private (set) lazy var lblDeclaration: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 91, green: 95, blue: 120, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 11)
        label.text = "Source of Income document would be required during the process."
        label.numberOfLines = 0
        return label
    }()
    private (set) lazy var closeBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "closegray"), for: .normal)
        btn.addTarget(self, action: #selector(didTapCloseBtn), for: .touchUpInside)
        return btn
    }()
    
    var supporterNameView: TextInputView!
    var supporterCNICView: TextInputView!
    var relaitonshipWithPrincipleView: ButtonPickerView!
    var supporterCnicIssueDateView: DatePickerView!
    var supporterCnicExpiryDateView: DatePickerView!
    var relationship: [OptionModel] = [OptionModel]()
    var accountHolder: PersonalInfoEntity.JointHolder?
    var filterRelationship: [OptionModel] = [OptionModel]()
    private var supporterNameTxt: String = ""
    private var supporterCNICTxt:  String = ""
    private var relaitonWithPrincipleTxt: String = ""
    private var supporterCnicIssueTxt: String = ""
    private var supporterCnicExpiryTxt: String = ""
    var dataSource: GenericPickerDataSource<OptionModel>?
    var datePicker: DatePickerDialog!
    
    weak var delegate: FundSupporterProtocol?
    var basicInfo: PersonalInfoEntity.BasicInfo
    var kycInfo: KYCModel?
    init(basicInfo: PersonalInfoEntity.BasicInfo, kycInfo: KYCModel?) {
        self.basicInfo = basicInfo
        self.kycInfo = kycInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          showCancelButton: true)
        if let data = Constant.setup_data {
            relationship = data.relationship ?? []
            filterRelationship = relationship
        }
        setUpView()
    }
    @objc private func didTapCloseBtn() {
        dismiss(animated: true, completion: nil)
    }
    
}
extension FundSupporterVC {
    private func setUpView() {
        self.supporterNameTxt = kycInfo?.fundSupporter?.name ?? ""
        self.relaitonWithPrincipleTxt = kycInfo?.fundSupporter?.relationShip ?? ""
        self.supporterCnicIssueTxt = kycInfo?.fundSupporter?.issueDate ?? ""
        self.supporterCnicExpiryTxt = kycInfo?.fundSupporter?.expiryDate ?? ""
        self.supporterCNICTxt = kycInfo?.fundSupporter?.cnicNo ?? ""
        
        
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        containerView.layer.cornerRadius = 4
        
        if !popupView.isDescendant(of: self.containerView) {
            self.containerView.addSubview(popupView)
        }
        popupView.backgroundColor = .white
        popupView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
        popupView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        popupView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        popupView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8).isActive = true
        
        
        
        if !scrollView.isDescendant(of: popupView) {
            popupView.addSubview(scrollView)
        }

        scrollView.topAnchor.constraint(equalTo: self.popupView.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.popupView.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.popupView.bottomAnchor, constant: -16).isActive = true

        if !contentView.isDescendant(of: scrollView) {
            scrollView.addSubview(contentView)
        }

        contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10 ).isActive = true
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
        
        
        
        
        stackView.addArrangedSubview(lblTitle)
        stackView.addArrangedSubview(lblDeclaration)
        supporterNameView = TextInputView(heading:  "Name", placeholder: "Name", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.supporterNameTxt = enteredText
        }
        supporterNameView.setData(text: supporterNameTxt)
        stackView.addArrangedSubview(supporterNameView)
        
        relaitonshipWithPrincipleView = ButtonPickerView(heading:  "Relationship With Principal", placeholder: "Relationship With Principal", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.filterRelationship,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: 0,  didSelect: { (data) in
                            self.relaitonshipWithPrincipleView?.txtField.text = data.name
                            self.relaitonWithPrincipleTxt = data.name ?? ""
                        })
            self.relaitonshipWithPrincipleView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        
        relaitonshipWithPrincipleView.setData(text: relaitonWithPrincipleTxt)
        stackView.addArrangedSubview(relaitonshipWithPrincipleView)
        
        
        supporterCNICView = TextInputView(heading:  AppString.Heading.cnicPassport, placeholder: "CNIC/NICOP/Passport", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.supporterCNICTxt = enteredText
        }
        supporterCNICView.setData(text: supporterCNICTxt)
        supporterCNICView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(supporterCNICView)

        supporterCnicIssueDateView = DatePickerView(heading:  AppString.Heading.cnicIssue, placeholder: AppString.Heading.cnicIssue, image: "calenderIcon") {
            
            var dateComponents = DateComponents()
            dateComponents.year = -75
            dateComponents.day = -1
            let minDate = Calendar.current.date(byAdding: dateComponents, to: Date() )
            dateComponents.year = 0
            let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
            self.datePicker.show("Date Picker",
                            doneButtonTitle: "Done",
                            cancelButtonTitle: "Cancel",
                            defaultDate: Date(),
                            minimumDate: minDate,
                            maximumDate: maxDate,
                            datePickerMode: .date) { (date) in
                                if let dt = date {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd"
                                    let dateValue = formatter.string(from: dt)
                                    self.supporterCnicIssueTxt = dateValue
                                    self.supporterCnicIssueDateView.txtField.text = dateValue
                                } else {
                                    self.supporterCnicIssueDateView.txtField.text = ""
                                }
            }
        }
        supporterCnicIssueDateView.setData(text: supporterCnicIssueTxt)
        stackView.addArrangedSubview(supporterCnicIssueDateView)
        
        
        supporterCnicExpiryDateView = DatePickerView(heading:  AppString.Heading.cnicExpiry, placeholder: AppString.Heading.cnicExpiry, image: "calenderIcon") {
            var dateComponents = DateComponents()
            dateComponents.year = 0
            dateComponents.day = +1
            let minDate = Calendar.current.date(byAdding: dateComponents, to: Date())
            dateComponents.year = 75
            let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
            self.datePicker.show("Date Picker",
                            doneButtonTitle: "Done",
                            cancelButtonTitle: "Cancel",
                            defaultDate: Date(),
                            minimumDate: minDate,
                            maximumDate: maxDate,
                            datePickerMode: .date) { (date) in
                                if let dt = date {
                                    let formatter = DateFormatter()
                                    formatter.dateFormat = "yyyy-MM-dd"
                                    let dateValue = formatter.string(from: dt)
                                    self.supporterCnicExpiryTxt = dateValue
                                    self.supporterCnicExpiryDateView.txtField.text = dateValue
                                } else {
                                    self.supporterCnicExpiryDateView.txtField.text = ""
                                }
            }
        }
        supporterCnicExpiryDateView.setData(text: supporterCnicExpiryTxt)
        stackView.addArrangedSubview(supporterCnicExpiryDateView)
        
        let isSelectedView = CheckBoxView(heading: AppString.Heading.validForLife, image: "checkbox") { isSelected in
            UIView.animate(withDuration: 0.5) {
                //self.isExpiry = isSelected
                self.supporterCnicExpiryDateView.isHidden = isSelected ? true : false
                if isSelected == true {
                    self.supporterCnicExpiryTxt = "2100-01-01"
                } else {
                    self.supporterCnicExpiryTxt = self.supporterCnicExpiryDateView.txtField.text ?? ""
                }
            }
        }
        stackView.addArrangedSubview(isSelectedView)
        if !closeBtn.isDescendant(of: self.popupView) {
            popupView.addSubview(closeBtn)
        }
        closeBtn.topAnchor.constraint(equalTo: self.popupView.topAnchor, constant: 8).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -8).isActive = true
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            
            if self.supporterNameTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your fund provider name.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if self.supporterCNICTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your fund provider CNIC.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.supporterCNICTxt.count < 13 {
                self.showAlert(title: "Alert", message: "Enter valid CNIC Number", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.relaitonWithPrincipleTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your relationship with fund provider.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.supporterCnicIssueTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter CNIC Issue Date.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.supporterCnicExpiryTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter CNIC Expiry Date.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            
            let info = FundSupporter(
                cnicNo: self.supporterCNICTxt,
                name: self.supporterNameTxt,
                relationShip: self.relaitonWithPrincipleTxt,
                issueDate: self.supporterCnicIssueTxt,
                expiryDate: self.supporterCnicExpiryTxt,
                cnic: self.basicInfo.cnic,
                accountType: self.basicInfo.accountType)
            self.delegate?.submitSupporterInfo(info)
            self.dismiss(animated: true, completion: nil)
        }
        
        stackView.addArrangedSubview(btnView)
        
    }
}

protocol FundSupporterProtocol: AnyObject {
    func submitSupporterInfo(_ info: FundSupporter)
}



struct FundSupporter: Codable {
    let cnicNo : String?
    let name : String?
    let relationShip : String?
    let issueDate : String?
    let expiryDate : String?
    let cnic : String?
    let accountType : String?

    enum CodingKeys: String, CodingKey {

        case cnicNo = "CnicNo"
        case name = "Name"
        case relationShip = "RelationShip"
        case issueDate = "IssueDate"
        case expiryDate = "ExpiryDate"
        case cnic = "Cnic"
        case accountType = "AccountType"
    }
}

