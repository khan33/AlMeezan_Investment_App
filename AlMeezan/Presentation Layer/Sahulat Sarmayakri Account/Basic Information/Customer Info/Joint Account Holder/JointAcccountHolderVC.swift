//
//  JointAcccountHolderVC.swift
//  AlMeezan
//
//  Created by Atta khan on 20/06/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit
import DatePickerDialog


class JointAcccountHolderVC: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "1 / 5", titleStr: "Basic Information", subTitle: "Joint Account Holder", numberOfPages: 5, currentPageNo: 0, closeAction: {
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
    
    
    
    var  router: GeographiesRouterProtocol = GeographiesRouter()
    var jointAccountNameView: TextInputView!
    var jointAccountCNICView: TextInputView!
    private var jointAccountNameTxt: String = ""
    private var jointAccountCNICTxt:  String = ""
    private var relaitonWithPrincipleTxt: String = ""
    private var jointHolderCnicIssueTxt: String = ""
    private var jointHolderCnicExpiryTxt: String = ""
    
    var relaitonshipWithPrincipleView: ButtonPickerView!
    var jointAcchountCnicIssueDateView: DatePickerView!
    var jointAcchountCnicExpiryDateView: DatePickerView!
    var relationship: [OptionModel] = [OptionModel]()
    var accountHolder: PersonalInfoEntity.JointHolder?
    var filterRelationship: [OptionModel] = [OptionModel]()
    
    var accountType: String = "BOTH"
    private var cnicTxt: String     =   ""
    var dataSource: GenericPickerDataSource<OptionModel>?
    var datePicker: DatePickerDialog!
    
    var basicInfo: PersonalInfoEntity.BasicInfo?
    init(basicInfo: PersonalInfoEntity.BasicInfo?) {
        self.basicInfo = basicInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router.navigationController = navigationController
        if let cnic = UserDefaults.standard.string(forKey: "CNIC") {
            cnicTxt = cnic
        }
        accountType = UserDefaults.standard.string(forKey: "accountType") ?? "BOTH"

        if let data = Constant.setup_data {
            relationship = data.relationship ?? []
            filterRelationship = relationship
        }
        
        if let martial_status = UserDefaults.standard.string(forKey: "maritalStatus") {
            if martial_status.uppercased() == "SINGLE" {
                var total = self.relationship.count
                while total > 4 {
                    total -= 1
                    self.filterRelationship.remove(at: total)
                }
            }
        }
        
        datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          showCancelButton: true)
        
        setUpView()
    }
    
    @objc private func didTapCloseBtn() {
        dismiss(animated: true, completion: nil)
    }

}
extension JointAcccountHolderVC {
    
    private func setUpView() {
        view.backgroundColor = .white
        if let info = basicInfo {
            jointAccountNameTxt = info.jointHolder?.fullName ?? ""
            jointAccountCNICTxt = info.jointHolder?.nic ?? ""
            relaitonWithPrincipleTxt = info.jointHolder?.relationship ?? ""
            jointHolderCnicIssueTxt = info.jointHolder?.issueDate ?? ""
            jointHolderCnicExpiryTxt = info.jointHolder?.expiryDate ?? ""
        }
        
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
        scrollView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16).isActive = true

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
        jointAccountNameView = TextInputView(heading:  "Name", placeholder: "Name", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.jointAccountNameTxt = enteredText
        }
        jointAccountNameView.setData(text: jointAccountNameTxt)
        stackView.addArrangedSubview(jointAccountNameView)
        
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
        
        
        jointAccountCNICView = TextInputView(heading:  AppString.Heading.cnicPassport, placeholder: "CNIC/NICOP/Passport", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.jointAccountCNICTxt = enteredText
        }
        jointAccountCNICView.setData(text: jointAccountCNICTxt)
        jointAccountCNICView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(jointAccountCNICView)

        jointAcchountCnicIssueDateView = DatePickerView(heading:  AppString.Heading.cnicIssue, placeholder: AppString.Heading.cnicIssue, image: "calenderIcon") {
            
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
                                    self.jointHolderCnicIssueTxt = dateValue
                                    self.jointAcchountCnicIssueDateView.txtField.text = dateValue
                                } else {
                                    self.jointAcchountCnicIssueDateView.txtField.text = ""
                                }
            }
        }
        jointAcchountCnicIssueDateView.setData(text: jointHolderCnicIssueTxt)
        stackView.addArrangedSubview(jointAcchountCnicIssueDateView)
        
        
        jointAcchountCnicExpiryDateView = DatePickerView(heading:  AppString.Heading.cnicExpiry, placeholder: AppString.Heading.cnicExpiry, image: "calenderIcon") {
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
                                    self.jointHolderCnicExpiryTxt = dateValue
                                    self.jointAcchountCnicExpiryDateView.txtField.text = dateValue
                                } else {
                                    self.jointAcchountCnicExpiryDateView.txtField.text = ""
                                }
            }
        }
        jointAcchountCnicExpiryDateView.setData(text: jointHolderCnicExpiryTxt)
        stackView.addArrangedSubview(jointAcchountCnicExpiryDateView)
        
        let isSelectedView = CheckBoxView(heading: AppString.Heading.validForLife, image: "checkbox") { isSelected in
            UIView.animate(withDuration: 0.5) {
                //self.isExpiry = isSelected
                self.jointAcchountCnicExpiryDateView.isHidden = isSelected ? true : false
                if isSelected == true {
                    self.jointHolderCnicExpiryTxt = "2100-01-01"
                } else {
                    self.jointHolderCnicExpiryTxt = self.jointAcchountCnicExpiryDateView.txtField.text ?? ""
                }
            }
        }
        stackView.addArrangedSubview(isSelectedView)
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            
            if self.jointAccountNameTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter joint account holder name.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if self.jointAccountCNICTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter joint account holder CNIC.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.jointAccountCNICTxt.count < 13 {
                self.showAlert(title: "Alert", message: "Enter valid CNIC Number", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.relaitonWithPrincipleTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter your relationship with joint account holder.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.jointHolderCnicIssueTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter CNIC Issue Date.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.jointHolderCnicExpiryTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter CNIC Expiry Date.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            let accountHolder = PersonalInfoEntity.JointHolder(fullName: self.jointAccountNameTxt, relationship: self.relaitonWithPrincipleTxt, nic: self.jointAccountCNICTxt, issueDate: self.jointHolderCnicIssueTxt, expiryDate: self.jointHolderCnicExpiryTxt, cnic: self.cnicTxt, accountType: self.accountType, fatca: self.basicInfo?.jointHolder?.fatca, crs: self.basicInfo?.jointHolder?.crs, pebDec: self.basicInfo?.jointHolder?.pebDec)
            self.basicInfo?.jointHolder = accountHolder
            
            self.router.routerToQuestionaireVC(basicinfo: self.basicInfo, KYCinfo: nil)
            
            
            
        }
        
        stackView.addArrangedSubview(btnView)
        
    }
}
