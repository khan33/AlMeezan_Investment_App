//
//  PersonalInfoVC.swift
//  AlMeezan
//
//  Created by Atta khan on 10/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit
import DatePickerDialog

class PersonalInfoVC: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "1 / 3", titleStr: "Basic Information", subTitle: AppString.Heading.personalInfo, numberOfPages: 3, currentPageNo: 0, closeAction: {
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
    
    
    
    var isJointAccountData: Bool = false
    var removeView: TermsAndConditionView!
    var joinAccountHolderView: DeclarationButton!
    var declarationBtnView: DeclarationButton!
    var router:PersonalInfoRouterProtocol?
    var interactor: PersonalInfoInteractorProtocol?
    private var nameTxt: String     =   ""
    private var fNameTxt: String    =   ""
    private var mNameTxt: String    =   ""
    private var cnicTxt: String     =   ""
    private var cnicIssueDateTxt: String     =   ""
    private var cnicExpiryDateTxt: String    =   ""
    private var isExpiry: Bool   =   false
    private var maritalStatusTxt: String     =   ""
    private var nationalityTxt: String     =   "PAKISTANI"
    private var dualNationalityTxt: String     =   ""
    private var residentialStatusTxt: String     =   ""
    private var religionTxt: String     =   ""
    private var isZakatExemption: String = "N"
    private var dateOfBirthTxt: String = ""
    private var dualCountryTxt: String = ""
    
    var isSelectedView: CheckBoxView!
    var datePicker: DatePickerDialog!
    var dobDate: DatePickerView!
    var cnicIssueDate: DatePickerView!
    var cnicExpiryDate: DatePickerView!
    var dataSource: GenericPickerDataSource<OptionModel>?
    var maritalStatusView: ButtonPickerView!
    var nationalityView: TextInputView!
    var dualNationalityView: ButtonPickerView!
    var residentialStatusView: ButtonPickerView!
    var religionView: ButtonPickerView!
    var zakatExemption: ZakatExemption?
    var dualCountryView: TextInputView!
    var jointAccountNameView: TextInputView!
    var jointAccountCNICView: TextInputView!
    // Selected Picker View Items
    var residentialStatusItem: Int = 0
    var dualNationalityItem: Int = 1
    var religionItem: Int = 0
    var maritalStatusItem: Int = 0
    
    var maritalStatus: [OptionModel] = [OptionModel]()
    var nationality: [OptionModel] = [OptionModel]()
    var residentialStatus: [OptionModel] = [OptionModel]()
    var religion: [OptionModel] = [OptionModel]()
    var basicInfo: PersonalInfoEntity.BasicInfo?
    var channel: String = "SSA"
    
    
    // Joint Account Holder
    
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
    var dualNationality: [OptionModel] = [OptionModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        dualNationality.append(
            contentsOf: [
                OptionModel(code: "", name: "YES", isActive: 0),
                OptionModel(code: "", name: "NO", isActive: 0),
            ]
        )
        UserDefaults.standard.set(false, forKey: "W9JointForm")
        if let data = Constant.setup_data {
            maritalStatus = data.maritalStatus ?? []
            religion = data.religion ?? []
            nationality = data.nationality ?? []
            residentialStatus = data.residentialStatus ?? []
            relationship = data.relationship ?? []
            filterRelationship = relationship

            if residentialStatus.count > 0 {
                residentialStatusTxt = residentialStatus[0].name ?? ""
            }
            if religion.count > 0 {
                religionTxt = religion[0].name ?? ""
            }
            
            if dualNationality.count > 0 {
                dualNationalityTxt = dualNationality[0].name ?? ""
            }
            
            if maritalStatus.count > 0 {
                maritalStatusTxt = maritalStatus[0].name ?? ""
            }
            
        }
        dualNationalityTxt = "NO"
        datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          showCancelButton: true)
        
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: Notification.Name("JointAccountHolder"), object: nil)
        
        
        if accountType == "VPS" || accountType == "BOTH" {
            if let _ = Constant.health_dec {
                self.declarationBtnView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
                self.declarationBtnView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
            }
        }
        
    }
    
    @objc func onDidReceiveData(_ notification: Notification) {
        if let info = notification.userInfo?["basicInfo"] {
            basicInfo = info as! PersonalInfoEntity.BasicInfo
            self.joinAccountHolderView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
            self.joinAccountHolderView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
        }
    }
    
    func getReligionItem(_ txt: String) {
        self.religionItem = self.religion.firstIndex(where: { $0.name == txt }) ?? 0
    }
    
    func setZakatStatus(_ txt: String) {
        if txt == "Non-Muslim" {
            zakatExemption?.noBtn.isUserInteractionEnabled = false
            zakatExemption?.affidavitLbl.text = ""
            zakatExemption?.yesBtn.isSelected = true
            zakatExemption?.noBtn.isSelected = false
        } else {
            zakatExemption?.noBtn.isUserInteractionEnabled = true
            zakatExemption?.affidavitLbl.text = "(NDZ-Non-Deduction Affidavit of Zakat is required)"
        }
    }
    
}
extension PersonalInfoVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        if let cnic = UserDefaults.standard.string(forKey: "CNIC") {
            cnicTxt = cnic
        }
        
        if let chanel = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            channel = chanel
        }
        accountType = UserDefaults.standard.string(forKey: "accountType") ?? "BOTH"

        
        
        if let info = Constant.CustomerData.customer_data?.cNICData?.basicInfo {
            basicInfo = info
            nameTxt = self.basicInfo?.fullName ?? ""
            fNameTxt = self.basicInfo?.fatherHusbandName ?? ""
            mNameTxt = self.basicInfo?.motherMaidenName ?? ""
            cnicTxt = self.basicInfo?.cnic ?? cnicTxt
            cnicIssueDateTxt = self.basicInfo?.cnicIssueDate ?? ""
            cnicExpiryDateTxt = self.basicInfo?.cnicExpiryDate ?? ""
            residentialStatusTxt = self.basicInfo?.residentialStatus ?? ""
            religionTxt = self.basicInfo?.religion ?? ""
            dualNationalityTxt = self.basicInfo?.dualNational ?? ""
            nationalityTxt = self.basicInfo?.nationality ?? ""
            maritalStatusTxt = self.basicInfo?.maritalStatus ?? ""
            dateOfBirthTxt = self.basicInfo?.dateOfBirth ?? ""
            isZakatExemption = self.basicInfo?.zakatStatus ?? "N"
            jointAccountNameTxt = self.basicInfo?.jointHolder?.fullName ?? ""
            jointAccountCNICTxt = self.basicInfo?.jointHolder?.nic ?? ""
            relaitonWithPrincipleTxt = self.basicInfo?.jointHolder?.relationship ?? ""
            jointHolderCnicIssueTxt = self.basicInfo?.jointHolder?.issueDate ?? ""
            jointHolderCnicExpiryTxt = self.basicInfo?.jointHolder?.expiryDate ?? ""
            setZakatStatus(religionTxt)
            UserDefaults.standard.set(self.maritalStatusTxt, forKey: "maritalStatus")
        }
        if accountType == "VPS" || accountType == "BOTH" {
            if let health_info = Constant.CustomerData.customer_data?.cNICData?.healthDec {
                Constant.health_dec = health_info
            }
        }
        
        
        getReligionItem(religionTxt)

        
        residentialStatusItem = residentialStatus.firstIndex(where: {$0.name == residentialStatusTxt}) ?? 0
        dualNationalityItem = dualNationality.firstIndex(where: {$0.name == dualNationalityTxt}) ?? 0
        
        maritalStatusItem = maritalStatus.firstIndex(where: {$0.name == maritalStatusTxt}) ?? 0
        
        if self.maritalStatusTxt == "Single" {
        var total = self.relationship.count
            while total > 4 {
                total -= 1
                self.filterRelationship.remove(at: total)
            }
        }
        
        if self.cnicExpiryDateTxt == "2100-01-01" {
            self.isExpiry = true
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
        
        let nameView = TextInputView(heading:  AppString.Heading.name, placeholder: AppString.PlaceHoderText.enterName, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.nameTxt = enteredText
        }
        nameView.txtField.autocapitalizationType = .allCharacters
        nameView.setData(text: nameTxt)
        stackView.addArrangedSubview(nameView)

        let fathterNameView = TextInputView(heading:  AppString.Heading.fName, placeholder: AppString.PlaceHoderText.enterFname, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.fNameTxt = enteredText
        }
        fathterNameView.txtField.autocapitalizationType = .allCharacters
        fathterNameView.setData(text: fNameTxt)
        stackView.addArrangedSubview(fathterNameView)

        let motherNameView = TextInputView(heading:  AppString.Heading.mName, placeholder: AppString.PlaceHoderText.enterMname, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.mNameTxt = enteredText
        }
        motherNameView.txtField.autocapitalizationType = .allCharacters
        motherNameView.setData(text: mNameTxt)
        stackView.addArrangedSubview(motherNameView)
        
        let CnicView = TextInputView(heading:  AppString.Heading.cnicNicop, placeholder: AppString.PlaceHoderText.enterCNICNICOP, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.cnicTxt = enteredText
        }
        CnicView.txtField.isUserInteractionEnabled = false
        CnicView.setData(text: cnicTxt)
        stackView.addArrangedSubview(CnicView)

        
        dobDate = DatePickerView(heading:  AppString.Heading.dob, placeholder: AppString.PlaceHoderText.enterDob, image: "calenderIcon") {
            
            var dateComponents = DateComponents()
            dateComponents.year = -75
            let minDate = Calendar.current.date(byAdding: dateComponents, to: Date() )
            dateComponents.year = -18
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
                                    self.dateOfBirthTxt = dateValue
                                    self.dobDate.txtField.text = dateValue
                                } else {
                                    self.dobDate.txtField.text = ""
                                }
            }
        }
        dobDate.setData(text: dateOfBirthTxt)
        stackView.addArrangedSubview(dobDate)
        
        
        
        cnicIssueDate = DatePickerView(heading:  AppString.Heading.cnicIssue, placeholder: AppString.PlaceHoderText.enterCNICIssueDate, image: "calenderIcon") {
            
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
                                    self.cnicIssueDateTxt = dateValue
                                    self.cnicIssueDate.txtField.text = dateValue
                                } else {
                                    self.cnicIssueDate.txtField.text = ""
                                }
            }
        }
        cnicIssueDate.setData(text: cnicIssueDateTxt)
        stackView.addArrangedSubview(cnicIssueDate)
        
        
        cnicExpiryDate = DatePickerView(heading:  AppString.Heading.cnicExpiry, placeholder: AppString.PlaceHoderText.enterCNICExpiryDate, image: "calenderIcon") {
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
                                    self.cnicExpiryDateTxt = dateValue
                                    self.cnicExpiryDate.txtField.text = dateValue
                                } else {
                                    self.cnicExpiryDate.txtField.text = ""
                                }
            }
        }
        cnicExpiryDate.setData(text: cnicExpiryDateTxt)
        stackView.addArrangedSubview(cnicExpiryDate)
        
        isSelectedView = CheckBoxView(heading: AppString.Heading.validForLife, image: "checkbox") { isSelected in
            UIView.animate(withDuration: 0.5) {
                self.isExpiry = isSelected
                self.cnicExpiryDate.isHidden = isSelected ? true : false
                if isSelected == true {
                    self.cnicExpiryDateTxt = "2100-01-01"
                } else {
                    self.cnicExpiryDateTxt = self.cnicExpiryDate.txtField.text ?? ""
                }
            }
        }
        if isExpiry == true {
            self.cnicExpiryDate.isHidden = true
            isSelectedView.btnIcon.isSelected = true
        }
        
        stackView.addArrangedSubview(isSelectedView)
        
        maritalStatusView = ButtonPickerView(heading:  AppString.Heading.materialStatus, placeholder: AppString.PlaceHoderText.enterMaterialStatus, image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.maritalStatus,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.residentialStatusItem,  didSelect: { (data) in
                            self.maritalStatusView?.txtField.text = data.name
                            self.maritalStatusTxt = data.name ?? ""
                            self.filterRelationship = self.relationship
                            if self.maritalStatusTxt == "Single" {
                            var total = self.relationship.count
                                while total > 4 {
                                    total -= 1
                                    self.filterRelationship.remove(at: total)
                                }
                            }
                            UserDefaults.standard.set(self.maritalStatusTxt, forKey: "maritalStatus")
                            
                        })
            self.maritalStatusView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        maritalStatusView.setData(text: maritalStatusTxt)
        stackView.addArrangedSubview(maritalStatusView)
        
        
        nationalityView = TextInputView(heading:  AppString.Heading.nationality, placeholder: AppString.PlaceHoderText.enterNationality, isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.nationalityTxt = enteredText
        }

        nationalityView.setData(text: nationalityTxt)
        stackView.addArrangedSubview(nationalityView)
        
        dualNationalityView = ButtonPickerView(heading:  AppString.Heading.dualNationality, placeholder: AppString.PlaceHoderText.enterDualNationality, image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.dualNationality,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.dualNationalityItem,  didSelect: { (data) in
                            self.dualNationalityView?.txtField.text = data.name
                            self.dualNationalityTxt = data.name ?? ""
                            if self.dualNationalityTxt.uppercased() == "YES" {
                                self.dualCountryView.isHidden = false
                            } else {
                                self.dualCountryView.isHidden = true
                            }
                        })
            self.dualNationalityView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        dualNationalityView.setData(text: dualNationalityTxt)
        stackView.addArrangedSubview(dualNationalityView)
        
        dualCountryView = TextInputView(heading:  "Country Name", placeholder: "Enter your name of your dual country", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.dualCountryTxt = enteredText
        }
        dualCountryView.setData(text: dualCountryTxt)
        stackView.addArrangedSubview(dualCountryView)
        
        dualCountryView.isHidden = true
        residentialStatusView = ButtonPickerView(heading:  AppString.Heading.residentaialStatus, placeholder: AppString.PlaceHoderText.enterResidentStatus, image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.residentialStatus,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.residentialStatusItem,  didSelect: { (data) in
                            self.residentialStatusView?.txtField.text = data.name
                            self.residentialStatusTxt = data.name ?? ""
                        })
            self.residentialStatusView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        residentialStatusView.setData(text: residentialStatusTxt)
        stackView.addArrangedSubview(residentialStatusView)
        
        
        zakatExemption = ZakatExemption(heading: "") { value in
            self.isZakatExemption = value
        }
        
        religionView = ButtonPickerView(heading:  AppString.Heading.religion, placeholder: AppString.PlaceHoderText.enterRelegion, image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.religion,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.religionItem,  didSelect: { (data) in
                            self.religionView?.txtField.text = data.name
                            self.religionTxt = data.name ?? ""
                            self.getReligionItem(self.religionTxt)
                            self.setZakatStatus(self.religionTxt)
                        })
            self.religionView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        religionView.setData(text: religionTxt)
        stackView.addArrangedSubview(religionView)
        
        if religionTxt != "Non-Muslim" {
            if isZakatExemption == "N"{
                
                zakatExemption?.yesBtn.isSelected = false
                zakatExemption?.noBtn.isSelected = true
            } else {
                zakatExemption?.yesBtn.isSelected = true
                zakatExemption?.noBtn.isSelected = false
            }
        } else {
            self.setZakatStatus(self.religionTxt)
        }
        stackView.addArrangedSubview(zakatExemption!)
        
        if accountType == "VPS" || accountType == "BOTH" {
            declarationBtnView = DeclarationButton(heading: AppString.Heading.healthDec, headingColor: UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1), image: "health", checkMarkIcon: "forward-icon") {
                let vc = HealthDeclarationVC()
                self.navigationController?.pushViewController(vc, animated: false)
            }
            stackView.addArrangedSubview(declarationBtnView)
        }
        
        if accountType == "CIS" || accountType == "BOTH" {
             joinAccountHolderView = DeclarationButton(heading: AppString.Heading.accountHolder, headingColor: UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1), image: "jointAccount", checkMarkIcon: "forward-icon") {
                 if self.validateField() {
                     if let _ = self.basicInfo {
                         self.basicInfo?.isJointAccount = true
                     } else {
                         let info = PersonalInfoEntity.BasicInfo(fullName: self.nameTxt, fatherHusbandName: self.fNameTxt, motherMaidenName: self.mNameTxt, cnicIssueDate: self.cnicIssueDateTxt, cnicExpiryDate: self.cnicExpiryDateTxt, dateOfBirth: self.dateOfBirthTxt, maritalStatus: self.maritalStatusTxt, zakatStatus: self.isZakatExemption, religion: self.religionTxt, nationality: self.nationalityTxt, dualNational: self.dualNationalityTxt, dualNationalCountry: self.dualCountryTxt ,residentialStatus: self.residentialStatusTxt, phoneNo: "", officeNo: "", mobileNo: "", mobileNetwork: "", ported: "", emailAddress: "", currentAddress: "", currentCity: "", currentCountry: "", permanentAddress: "", permanentCity: "", permanentCountry: "", bankName: "", bankAccountNo: "", branchName: "", branchCity: "", cashDividend: "", stockDividend: "", nextOfKin: nil, jointHolder: nil , simOwner: nil, daoID: "", cnic: self.cnicTxt, accountType: self.accountType, channel: self.channel, isJointAccount: true)
                         self.basicInfo = info
                     }
                     let vc =  JointAcccountHolderVC(basicInfo: self.basicInfo)
                     self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            stackView.addArrangedSubview(joinAccountHolderView)
            
            
            if basicInfo?.jointHolder != nil {
                self.joinAccountHolderView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
                self.joinAccountHolderView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
                UserDefaults.standard.set(true, forKey: "W9JointForm")
            }
            
        }
        
        removeView = TermsAndConditionView(heading: "Remove Joint Account Holder Data", selectedCheckboxCloser: { isSelect in
            self.isJointAccountData = isSelect
            if isSelect == true {
                self.showConfirmationAlertViewWithTitle(title: "Alert", message: "Are you sure you want to remove joint account holder data?") {
                    self.removeView.checkBtn.isSelected = true
                    self.joinAccountHolderView.checkMarkBtn.setImage(UIImage(named: "forward-icon"), for: .normal)
                    self.joinAccountHolderView.lblHeading.textColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1)
                    self.joinAccountHolderView.isUserInteractionEnabled = false

                }
                self.removeView.checkBtn.isSelected = false
            } else {
                self.joinAccountHolderView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
                self.joinAccountHolderView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)

                self.joinAccountHolderView.isUserInteractionEnabled = true
            }
        })
        stackView.addArrangedSubview(removeView)
        
        if basicInfo?.jointHolder != nil {
            removeView.isHidden = false
        } else {
            removeView.isHidden = true
        }
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            self.validateField()
            
            if self.accountType == "VPS" || self.accountType == "BOTH" {
                if Constant.health_dec == nil {
                    self.showAlert(title: "Alert", message: "Please provide detail of Health Declaration.", controller: self) {
                        
                    }
                    return
                }
            }
            
            self.accountHolder = self.basicInfo?.jointHolder
             

            let info = PersonalInfoEntity.BasicInfo(fullName: self.nameTxt, fatherHusbandName: self.fNameTxt, motherMaidenName: self.mNameTxt, cnicIssueDate: self.cnicIssueDateTxt, cnicExpiryDate: self.cnicExpiryDateTxt, dateOfBirth: self.dateOfBirthTxt, maritalStatus: self.maritalStatusTxt, zakatStatus: self.isZakatExemption, religion: self.religionTxt, nationality: self.nationalityTxt, dualNational: self.dualNationalityTxt, dualNationalCountry: self.dualCountryTxt, residentialStatus: self.residentialStatusTxt, phoneNo: "", officeNo: "", mobileNo: "", mobileNetwork: "", ported: "", emailAddress: "", currentAddress: "", currentCity: "", currentCountry: "", permanentAddress: "", permanentCity: "", permanentCountry: "", bankName: "", bankAccountNo: "", branchName: "", branchCity: "", cashDividend: "", stockDividend: "", nextOfKin: nil, jointHolder: self.accountHolder ?? nil, simOwner: nil, daoID: "90", cnic: self.cnicTxt, accountType: self.accountType, channel: self.channel)
            self.router?.routerToContactInfoVC(info: info)

            
            
        }
        
        stackView.addArrangedSubview(btnView)
        if accountType == "VPS" || accountType == "BOTH" {
            if let _ = Constant.CustomerData.customer_data?.cNICData?.healthDec {
                self.declarationBtnView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
                self.declarationBtnView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
            }
        }
        
        
        
    }
    
    private func validateField() -> Bool {
        
        if self.nameTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your name.", controller: self) {
            }
            return false
        }
        if self.fNameTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your father/husband name.", controller: self) {
            }
            return false
        }
        if self.mNameTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your mother name.", controller: self) {
            }
            return false
        }
        if self.cnicTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your CNIC.", controller: self) {
            }
            return false
        }
        if self.dateOfBirthTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your date of birth.", controller: self) {
            }
            return false
        }
        if self.cnicIssueDateTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your CNIC issue date.", controller: self) {
            }
            return false
        }
        if self.cnicExpiryDateTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your CNIC Expiry date.", controller: self) {
            }
            return false
        }
        if self.nationalityTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your Nationality.", controller: self) {
            }
            return false
        }
        if self.dualNationalityTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your dual Nationality.", controller: self) {
            }
            return false
        }
        
        if self.maritalStatusTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your Marital Status.", controller: self) {
            }
            return false
        }
        
        if self.residentialStatusTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your Residential Status.", controller: self) {
            }
            return false
        }
        
        if self.religionTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your Religion.", controller: self) {
            }
            return false
        }
        return true
    }
    private func highlightJointAccountView() {
        self.joinAccountHolderView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
        self.joinAccountHolderView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
        self.removeView.isHidden = false
    }
}


extension PersonalInfoVC: PersonalInfoViewProtocol {
    
    func sucessResponse(resposne : [SubmissionResponse]) {
        
        if resposne[0].errID == "00" {
            if let info = self.basicInfo {
                self.router?.routerToContactInfoVC(info: info)
            }
        }
    }
    
    func failureResponse() {
        
    }
    
}
