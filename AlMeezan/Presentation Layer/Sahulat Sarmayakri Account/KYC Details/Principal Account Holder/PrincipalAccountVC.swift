//
//  PrincipalAccountVC.swift
//  AlMeezan
//
//  Created by Atta khan on 13/12/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class PrincipalAccountVC: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "1 / 3", titleStr: "KYC", subTitle: "Principal Account Holder" ,numberOfPages: 3, currentPageNo: 0, closeAction: {
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
    
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 35, green: 39, blue: 79, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 14)
        label.attributedText = NSAttributedString(string: "Click here to check required documents", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.isUserInteractionEnabled = true
        return label
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
        view.isHidden = true
        return view
    }()
    
    private (set) lazy var popupView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 6
        view.isHidden = true
        return view
    }()
    
    private (set) lazy var descHeadingLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = "REQUIRED DOCUMENTS"
        label.numberOfLines = 0
        label.font = UIFont(name: AppFontName.robotoMedium, size: 16)
        return label
    }()
    
    private (set) lazy var descLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont(name: AppFontName.robotoRegular, size: 15)
        return label
    }()
    
    private (set) lazy var acknowledgeBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setTitle("OK", for: .normal)
        btn.setTitleColor(UIColor.init(rgb: 0x8A269B), for: .normal)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(removeBlurView), for: .touchUpInside)
        return btn
    }()
    
    
    private var sourceOfIncomTxt: String         =   ""
    private var sourceOfWealthTxt: String       =   ""
    private var nameOfEmployerTxt: String?
    private var designationTxt: String?
    private var natureOfBusinessTxt: String?
    private var educationTxt: String   =   ""
    private var professionTxt: String    =   ""
    private var professionCode: String    =   "11"
    private var hearAboutTxt: String = ""
    private var duoIDTxt: String = ""
    private var otherSourceOfIncomTxt: String         =   ""
    private var otherSourceOfWealthTxt: String       =   ""
    private var otherEducationTxt: String       =   ""
    private var otherProfessionTxt: String       =   ""
    var educationView: ButtonPickerView!
    var professionView: ButtonPickerView!
    var sourceOfIncomeView: ButtonPickerView!
    var sourceOfWealthView: ButtonPickerView!
    var natureOfBusinessView: TextInputView!
    var nameOfEmployerView: TextInputView!
    var designationView: TextInputView!
    var hearAboutButtonView: ButtonPickerView!
    var providerView: DeclarationButton!
    var dataSource: GenericPickerDataSource<OptionModel>?
    var sourceOfIncome: [OptionModel] = [OptionModel]()
    var sourceOfWealth: [OptionModel] = [OptionModel]()
    var profession: [OptionModel] = [OptionModel]()
    var education: [OptionModel] = [OptionModel]()
    var hearAbout: [OptionModel] = [OptionModel]()
    
    // Selected Picker View Items
    var sourceOfIncomeItem: Int = 0
    var sourceOfWealthItem: Int = 0
    var hearAboutItem: Int = 0
    var professionItem: Int = 0
    var educationItem: Int = 0
    var sourceOfIncomeDocument: String = ""
    var sourceOfIncomeOtherView: TextInputView!
    var sourceOfWealthOtherView: TextInputView!
    var educationOtherView: TextInputView!
    var professionOtherView: TextInputView!
    var fundSupporter_data: FundSupporter?
    var router: PrincipalAccountRouterProtocol?
    var kycInfo: KYCModel?
    var basicInfo: PersonalInfoEntity.BasicInfo
    init(basicInfo: PersonalInfoEntity.BasicInfo) {
        self.basicInfo = basicInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    var onlineAccountType: String = OnlineAccountType.SSA.rawValue
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let account = UserDefaults.standard.string(forKey: "OnlineAccountType") {
            onlineAccountType = account
        }
        router?.navigationController = navigationController
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnDocumentLbl))
        lblTitle.addGestureRecognizer(tap)

        if let data = Constant.setup_data {
            sourceOfIncome = data.sourceOfIncome ?? []
            sourceOfWealth = data.sourceOfWealth ?? []
            education = data.education ?? []
            profession = data.profession ?? []
        }
        
        hearAbout.append(
            contentsOf: [
                OptionModel(code: "", name: "NEWSPAPER/ADVERTISING", isActive: 0),
                OptionModel(code: "", name: "EMAIL/SMS", isActive: 0),
                OptionModel(code: "", name: "TEAM MEMBER OF ALMEEZAN", isActive: 0),
                OptionModel(code: "", name: "SOCIAL MEDIA", isActive: 0),
                OptionModel(code: "", name: "TELE MARKETTING", isActive: 0),
                OptionModel(code: "", name: "DISTRIBUTORS", isActive: 0),
                OptionModel(code: "", name: "OTHERS", isActive: 0)
            ]
        )
        hearAboutTxt = "NEWSPAPER/ADVERTISING"
        
        setupViews()
    }
    @IBAction func didTapOnDocumentLbl(sender: UITapGestureRecognizer) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = KYC_DETAILS_PRINCIPAL
        vc.titleStr = "KYC DETAILS OF PRINCIPAL"
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func removeBlurView() {
        self.blurView.isHidden = true
        self.popupView.isHidden = true
    }
    @objc func doneButtonTapped() {
        self.descLbl.attributedText = sourceOfIncomeDocument.htmlToAttributedString
        self.sourceOfIncomeView?.txtField.resignFirstResponder()
        self.blurView.isHidden = false
        self.popupView.isHidden = false
    }
}
extension PrincipalAccountVC {
    fileprivate func setupViews() {
        
        self.view.backgroundColor = .white
        if let info = Constant.CustomerData.customer_data?.cNICData?.kyc {
            kycInfo = info
        }
        sourceOfIncomTxt = kycInfo?.sourceOfIncome ?? ""
        sourceOfWealthTxt = kycInfo?.sourceOfWealth ?? ""
        duoIDTxt = kycInfo?.daoID ?? "90"
        hearAboutTxt = kycInfo?.whereDidYouHearAboutUs ?? ""
        fundSupporter_data = kycInfo?.fundSupporter
        nameOfEmployerTxt = kycInfo?.nameOfEmployer
        natureOfBusinessTxt = kycInfo?.natureOfBusiness
        educationTxt = kycInfo?.education ?? ""
        designationTxt = kycInfo?.designation
        professionCode = kycInfo?.profession ?? ""
        
        if let i = profession.firstIndex(where: { $0.code == professionCode }) {
            professionTxt = profession[i].name ?? ""
        }

        
        sourceOfWealthItem = sourceOfWealth.firstIndex(where: {$0.name == sourceOfWealthTxt}) ?? 0
        sourceOfIncomeItem = sourceOfIncome.firstIndex(where: {$0.name == sourceOfIncomTxt}) ?? 0
        hearAboutItem = hearAbout.firstIndex(where: { $0.name == hearAboutTxt}) ?? 0
        professionItem = profession.firstIndex(where: { $0.code == professionCode}) ?? 0
        educationItem = education.firstIndex(where: { $0.name == educationTxt}) ?? 0
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
        
        if onlineAccountType == OnlineAccountType.digital.rawValue {
            stackView.addArrangedSubview(lblTitle)
        }
        
        sourceOfIncomeView = ButtonPickerView(heading:  "Source Of Income", placeholder: "Source 0f Income", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.sourceOfIncome,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.sourceOfIncomeItem,  didSelect: { (data) in
                            self.sourceOfIncomeView?.txtField.text = data.name
                            self.sourceOfIncomTxt = data.name ?? ""
                            self.sourceOfIncomeOtherView.isHidden = true
                            self.sourceOfIncomeItem = self.sourceOfIncome.firstIndex(where: {$0.name == data.name}) ?? 0
                            if self.sourceOfIncomTxt == "Other" {
                                self.sourceOfIncomeOtherView.isHidden = false
                            }
                            if self.onlineAccountType == OnlineAccountType.digital.rawValue {
                                if let document = data.Documents {
                                    self.sourceOfIncomeDocument = document
                                    UserDefaults.standard.set(document, forKey: "document")
                                }
                                if self.sourceOfIncomTxt == "Student" || self.sourceOfIncomTxt == "House Wife" {
                                    self.providerView.isHidden = false
                                } else {
                                    self.providerView.isHidden = true
                                }
                                UserDefaults.standard.set(self.sourceOfIncomTxt, forKey: "SourceOfIncome")
                                
                                if self.sourceOfIncomTxt == "Business/Self-Employed" || self.sourceOfIncomTxt == "Freelancer" || self.sourceOfIncomTxt == "Salary" {
                                    self.natureOfBusinessView.isHidden = false
                                    self.designationView.isHidden = false
                                    self.nameOfEmployerView.isHidden = false
                                } else {
                                    self.natureOfBusinessView.isHidden = true
                                    self.designationView.isHidden = true
                                    self.nameOfEmployerView.isHidden = true
                                }
                            }
                        })
            self.sourceOfIncomeView?.txtField.setupPickerField(withDataSource: self.dataSource!)
            if self.onlineAccountType == OnlineAccountType.digital.rawValue {
                self.sourceOfIncomeView?.txtField.addDoneToolbar(onDone: (target: self, action: #selector(self.doneButtonTapped)))
            }
        }
        sourceOfIncomeView.setData(text: sourceOfIncomTxt)
        stackView.addArrangedSubview(sourceOfIncomeView)
        
        
        sourceOfIncomeOtherView = TextInputView(heading:  "Other", placeholder: "Other", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.sourceOfIncomTxt = "Other - " + enteredText
            self.otherSourceOfIncomTxt = enteredText
        }
        
        stackView.addArrangedSubview(sourceOfIncomeOtherView)
        
        sourceOfWealthView = ButtonPickerView(heading:  "Source Of Wealth", placeholder: "Source Of Wealth", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.sourceOfWealth,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.sourceOfWealthItem,  didSelect: { (data) in
                            self.sourceOfWealthView?.txtField.text = data.name
                            self.sourceOfWealthTxt = data.name ?? ""
                            
                            self.sourceOfWealthOtherView.isHidden = true
                            if self.sourceOfWealthTxt == "Other" {
                                self.sourceOfWealthOtherView.isHidden = false
                            }
                            
                        })
            self.sourceOfWealthView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        sourceOfWealthView.setData(text: sourceOfWealthTxt)
        stackView.addArrangedSubview(sourceOfWealthView)

        
        sourceOfWealthOtherView = TextInputView(heading:  "Other", placeholder: "Other", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.sourceOfWealthTxt = "Other - " + enteredText
            self.otherSourceOfWealthTxt = enteredText
        }
        stackView.addArrangedSubview(sourceOfWealthOtherView)
        
        let other = "Other - "
        if sourceOfIncomTxt.contains(other) {
            sourceOfIncomeOtherView.isHidden = false
            let arr = sourceOfIncomTxt.components(separatedBy: "-")
            if arr.count > 0 {
                sourceOfIncomeOtherView.setData(text: arr[1])
                sourceOfIncomeView.setData(text: arr[0])
                otherSourceOfIncomTxt = arr[1]
            }
        } else {
            sourceOfIncomeOtherView.isHidden = true
        }
        
        if sourceOfWealthTxt.contains(other) {
            sourceOfWealthOtherView.isHidden = false
            let arr = sourceOfWealthTxt.components(separatedBy: "-")
            if arr.count > 0 {
                sourceOfWealthView.setData(text: arr[0])
                sourceOfWealthOtherView.setData(text: arr[1])
                otherSourceOfWealthTxt = arr[1]
            }
        } else {
            sourceOfWealthOtherView.isHidden = true
        }
        
        if onlineAccountType == OnlineAccountType.digital.rawValue {
            
             nameOfEmployerView = TextInputView(heading:  "Name of Employer/Business", placeholder: "Name of Employer/Business", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.nameOfEmployerTxt = enteredText
            }
            nameOfEmployerView.setData(text: nameOfEmployerTxt)
            stackView.addArrangedSubview(nameOfEmployerView)
            designationView = TextInputView(heading:  "Designation", placeholder: "Designation", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.designationTxt = enteredText
            }
            designationView.setData(text: designationTxt)
            stackView.addArrangedSubview(designationView)
            
            natureOfBusinessView = TextInputView(heading:  "Nature of business", placeholder: "Select Nature of business", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.natureOfBusinessTxt = enteredText
            }
            natureOfBusinessView.setData(text: natureOfBusinessTxt)
            stackView.addArrangedSubview(natureOfBusinessView)
    
            if self.sourceOfIncomTxt == "Business/Self-Employed" || self.sourceOfIncomTxt == "Freelancer" || self.sourceOfIncomTxt == "Salary" {
                natureOfBusinessView.isHidden = false
                designationView.isHidden = false
                nameOfEmployerView.isHidden = false
            } else {
                natureOfBusinessView.isHidden = true
                designationView.isHidden = true
                nameOfEmployerView.isHidden = true
            }
            
            
            
            
            educationView = ButtonPickerView(heading:  "Education", placeholder: "Select Education", image: "down_Arrow") {
                 self.dataSource = GenericPickerDataSource<OptionModel>(
                     withItems: self.education,
                             withRowTitle: { (data) -> String in
                                 return data.name ?? ""
                             }, row: self.educationItem,  didSelect: { (data) in
                                 self.educationView?.txtField.text = data.name
                                 self.educationTxt = data.name ?? ""
                                 
                                 self.educationOtherView.isHidden = true
                                 if self.educationTxt == "Other" {
                                     self.educationOtherView.isHidden = false
                                 }
                             })
                 self.educationView?.txtField.setupPickerField(withDataSource: self.dataSource!)
            }
            educationView.setData(text: educationTxt)
            stackView.addArrangedSubview(educationView)
            
            
            educationOtherView = TextInputView(heading:  "Other", placeholder: "Other", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.educationTxt = "Other - " + enteredText
                self.otherEducationTxt = enteredText
            }
            
            stackView.addArrangedSubview(educationOtherView)
            
            
            professionView = ButtonPickerView(heading:  "Profession", placeholder: "Select Profession", image: "down_Arrow") {
                 self.dataSource = GenericPickerDataSource<OptionModel>(
                     withItems: self.profession,
                             withRowTitle: { (data) -> String in
                                 return data.name ?? ""
                             }, row: self.professionItem,  didSelect: { (data) in
                                 self.professionView?.txtField.text = data.name
                                 self.professionTxt = data.name ?? ""
                                 self.professionCode = data.code ?? "11"
                                 self.professionOtherView.isHidden = true
                                 if self.professionTxt == "Other" {
                                     self.professionOtherView.isHidden = false
                                 }
                                 
                             })
                 self.professionView?.txtField.setupPickerField(withDataSource: self.dataSource!)
            }
            professionView.setData(text: professionTxt)
            stackView.addArrangedSubview(professionView)
            
            professionOtherView = TextInputView(heading:  "Other", placeholder: "Other", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.professionTxt = "Other - " + enteredText
                self.otherProfessionTxt = enteredText
            }
            
            stackView.addArrangedSubview(professionOtherView)
            
            
            
            if professionTxt.contains(other) {
                professionOtherView.isHidden = false
                let arr = professionTxt.components(separatedBy: "-")
                if arr.count > 0 {
                    professionView.setData(text: arr[0])
                    professionOtherView.setData(text: arr[1])
                    otherProfessionTxt = arr[1]
                }
            } else {
                professionOtherView.isHidden = true
            }
            
            if educationTxt.contains(other) {
                educationOtherView.isHidden = false
                let arr = educationTxt.components(separatedBy: "-")
                if arr.count > 0 {
                    educationView.setData(text: arr[0])
                    educationOtherView.setData(text: arr[1])
                    otherEducationTxt = arr[1]
                }
            } else {
                educationOtherView.isHidden = true
            }
            
            
            
            
        }
        let duoIDView = TextInputView(heading:  AppString.Heading.salePersonId, placeholder: "Enter Sales Person Id", isPasswordEnable: false) { [weak self] (enteredText) in
                guard let self = self else {return}
                self.duoIDTxt = enteredText
            }
        
        duoIDView.setData(text: duoIDTxt)
        duoIDView.txtField.keyboardType = .asciiCapableNumberPad
        
        
        hearAboutButtonView = ButtonPickerView(heading:  "Where Did You Hear About Us?", placeholder: "Select Where Did You Hear About Us", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.hearAbout,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.hearAboutItem,  didSelect: { (data) in
                            self.hearAboutButtonView?.txtField.text = data.name
                            self.hearAboutTxt = data.name ?? ""
                            if self.hearAboutTxt == "TEAM MEMBER OF ALMEEZAN" {
                                duoIDView.isHidden = false
                                duoIDView.txtField.text = ""
                                self.duoIDTxt = ""
                            } else {
                                duoIDView.isHidden = true
                                self.duoIDTxt = "90"
                            }
                        })
            self.hearAboutButtonView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        hearAboutButtonView.setData(text: hearAboutTxt)
        stackView.addArrangedSubview(hearAboutButtonView)
        
        if hearAboutTxt == "TEAM MEMBER OF ALMEEZAN" {
            //self.duoIDTxt = ""
            duoIDView.isHidden = false
        } else {
            self.duoIDTxt = "90"
            duoIDView.isHidden = true
        }
        
        duoIDView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(duoIDView)
        if onlineAccountType == OnlineAccountType.digital.rawValue {
        
            providerView = DeclarationButton(heading: "Provider/ Supporter declaration", headingColor: UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1), image: "jointAccount", checkMarkIcon: "forward-icon") {
                
                let vc =  FundSupporterVC(basicInfo: self.basicInfo, kycInfo:  self.kycInfo ?? nil)
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                vc.delegate = self
                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
            }
            stackView.addArrangedSubview(providerView)
            if self.sourceOfIncomTxt == "Student" || self.sourceOfIncomTxt == "House Wife" {
                self.providerView.isHidden = false
                if let _ = Constant.CustomerData.customer_data?.cNICData?.kyc?.fundSupporter {
                    self.providerView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
                    self.providerView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
                }
                
            } else {
                self.providerView.isHidden = true
            }
        }
       
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            
            if self.sourceOfIncomTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter source of income.", controller: self) {
                }
                return
            }
            
            
            
            
            let other = "Other"
            if self.sourceOfIncomTxt.contains(other) {
                if self.otherSourceOfIncomTxt == "" {
                    self.showAlert(title: "Alert", message: "Please enter other.", controller: self) {
                    }
                    return
                }
            }
            
            if self.sourceOfWealthTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter source of wealth.", controller: self) {
                }
                return
            }
            
            
            if self.sourceOfWealthTxt.contains(other) {
                if self.otherSourceOfWealthTxt == "" {
                    self.showAlert(title: "Alert", message: "Please enter other.", controller: self) {
                    }
                    return
                }
            }
            
            if self.onlineAccountType == OnlineAccountType.digital.rawValue {
                if self.sourceOfIncomTxt == "Business/Self-Employed" || self.sourceOfIncomTxt == "Freelancer" || self.sourceOfIncomTxt == "Salary" {
                    if self.nameOfEmployerTxt == ""{
                        self.showAlert(title: "Alert", message: "Please enter Employer/Business.", controller: self) {
                        }
                        return
                    }
                    
                    if self.designationTxt == ""{
                        self.showAlert(title: "Alert", message: "Please enter  designation.", controller: self) {
                        }
                        return
                    }
                    
                    
                    if self.natureOfBusinessTxt == ""{
                        self.showAlert(title: "Alert", message: "Please enter nature of business.", controller: self) {
                        }
                        return
                    }
                }
                
                
                
                if self.educationTxt == ""{
                    self.showAlert(title: "Alert", message: "Please select education.", controller: self) {
                    }
                    return
                }
                
                
                if self.educationTxt.contains(other) {
                    if self.otherEducationTxt == "" {
                        self.showAlert(title: "Alert", message: "Please enter other.", controller: self) {
                        }
                        return
                    }
                }
                
                
                if self.professionTxt == ""{
                    self.showAlert(title: "Alert", message: "Please select profession.", controller: self) {
                    }
                    return
                }
                
                
                if self.professionTxt.contains(other) {
                    if self.otherProfessionTxt == "" {
                        self.showAlert(title: "Alert", message: "Please enter other.", controller: self) {
                        }
                        return
                    }
                }
            }
            if self.hearAboutTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter where did you hear about us?.", controller: self) {
                }
                return
            }
            if self.duoIDTxt == "" {
                self.showAlert(title: "Alert", message: "Please enter sales person Id", controller: self) {
                }
                return
            }
            if self.onlineAccountType == OnlineAccountType.digital.rawValue {
                if self.sourceOfIncomTxt == "Student" || self.sourceOfIncomTxt == "House Wife" {
                    if self.fundSupporter_data?.name == nil || self.fundSupporter_data?.cnicNo == nil || self.fundSupporter_data?.issueDate == nil || self.fundSupporter_data?.expiryDate == nil || self.fundSupporter_data?.relationShip == nil {
                        self.showAlert(title: "Alert", message: "Please provide your fund supporter detail.", controller: self) {

                        }
                        return
                    }
                }
            }
            let info = KYCModel(
                residentialStatus: "",
                sourceOfIncome: self.sourceOfIncomTxt,
                sourceOfWealth: self.sourceOfWealthTxt,
                nameOfEmployer: self.nameOfEmployerTxt,
                designation: self.designationTxt,
                natureOfBusiness: self.natureOfBusinessTxt,
                education: self.educationTxt,
                profession: self.professionCode,
                geographiesDomestic: "",
                geographiesIntl: "",
                counterPartyDomestic: "",
                counterPartyIntl: "",
                modeOfTransaction: "",
                numberOfTransaction: "",
                expectedTurnOverMonthlyAnnual: "",
                expectedTurnOver: "",
                expectedInvestmentAmount: "",
                annualIncome: "",
                actionOnBehalfOfOther: 0,
                refusedYourAccount: 0,
                seniorPositionInGovtInstitute: 0,
                seniorPositionInPoliticalParty: 0,
                financiallyDependent: 0,
                highValueGoldSilverDiamond: 0,
                incomeIsHighRisk: 0,
                headOfState: 0,
                seniorMilitaryOfficer: 0,
                headOfDeptOrIntlOrg: 0,
                memberOfBoard: 0,
                memberOfNationalSenate: 0,
                politicalPartyOfficials: 0,
                pep_Declaration: "",
                whereDidYouHearAboutUs: self.hearAboutTxt,
                daoID: self.duoIDTxt,
                cnic: self.basicInfo.cnic,
                accountType: self.basicInfo.accountType,
                fundSupporter: self.fundSupporter_data
            )
            self.router?.routerToKYCGeographicVC(basicinfo: self.basicInfo, KYCinfo: info)
        }
        stackView.addArrangedSubview(btnView)
        
        
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
        popupView.heightAnchor.constraint(equalTo: blurView.heightAnchor, multiplier: 0.25).isActive = true
        
        if !descHeadingLbl.isDescendant(of: popupView) {
            self.popupView.addSubview(descHeadingLbl)
        }
        
        descHeadingLbl.leadingAnchor.constraint(equalTo: self.popupView.leadingAnchor, constant: 16).isActive = true
        descHeadingLbl.topAnchor.constraint(equalTo: self.popupView.topAnchor, constant: 16).isActive = true
        
        descHeadingLbl.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -16).isActive = true
        
        
        if !descLbl.isDescendant(of: self.popupView) {
            self.popupView.addSubview(descLbl)
        }
        
        descLbl.leadingAnchor.constraint(equalTo: self.popupView.leadingAnchor, constant: 16).isActive = true
        descLbl.topAnchor.constraint(equalTo: self.descHeadingLbl.bottomAnchor, constant: 16).isActive = true
        
        descLbl.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -16).isActive = true
        
        
        if !acknowledgeBtn.isDescendant(of: self.popupView) {
            self.popupView.addSubview(acknowledgeBtn)
        }
        
        acknowledgeBtn.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -16).isActive = true
        acknowledgeBtn.bottomAnchor.constraint(equalTo: self.popupView.bottomAnchor, constant: -16).isActive = true
        
    }
    
    
}

extension PrincipalAccountVC: FundSupporterProtocol {
    func submitSupporterInfo(_ info: FundSupporter) {
        fundSupporter_data = info
        if fundSupporter_data != nil {
            self.providerView.checkMarkBtn.setImage(UIImage(named: "complete-icon"), for: .normal)
            self.providerView.lblHeading.textColor = UIColor.rgb(red: 71, green: 174, blue: 10, alpha: 1)
        }
    }
    
    
}

struct KYCModel : Codable {
    let residentialStatus : String?
    let sourceOfIncome : String?
    let sourceOfWealth : String?
    let nameOfEmployer : String?
    let designation : String?
    let natureOfBusiness : String?
    let education : String?
    let profession : String?
    let geographiesDomestic : String?
    let geographiesIntl : String?
    let counterPartyDomestic : String?
    let counterPartyIntl : String?
    let modeOfTransaction : String?
    let numberOfTransaction : String?
    let expectedTurnOverMonthlyAnnual : String?
    let expectedTurnOver : String?
    let expectedInvestmentAmount : String?
    let annualIncome : String?
    let actionOnBehalfOfOther : Int?
    let refusedYourAccount : Int?
    let seniorPositionInGovtInstitute : Int?
    let seniorPositionInPoliticalParty : Int?
    let financiallyDependent : Int?
    let highValueGoldSilverDiamond :Int?
    let incomeIsHighRisk : Int?
    let headOfState : Int?
    let seniorMilitaryOfficer : Int?
    let headOfDeptOrIntlOrg : Int?
    let memberOfBoard : Int?
    let memberOfNationalSenate : Int?
    let politicalPartyOfficials : Int?
    let pep_Declaration : String?
    let whereDidYouHearAboutUs : String?
    let daoID : String?
    let cnic : String?
    let accountType : String?
    let fundSupporter: FundSupporter?
    enum CodingKeys: String, CodingKey {

        case residentialStatus = "ResidentialStatus"
        case sourceOfIncome = "SourceOfIncome"
        case sourceOfWealth = "SourceOfWealth"
        case nameOfEmployer = "NameOfEmployer"
        case designation = "Designation"
        case natureOfBusiness = "NatureOfBusiness"
        case education = "Education"
        case profession = "Profession"
        case geographiesDomestic = "GeographiesDomestic"
        case geographiesIntl = "GeographiesIntl"
        case counterPartyDomestic = "CounterPartyDomestic"
        case counterPartyIntl = "CounterPartyIntl"
        case modeOfTransaction = "ModeOfTransaction"
        case numberOfTransaction = "NumberOfTransaction"
        case expectedTurnOverMonthlyAnnual = "ExpectedTurnOverMonthlyAnnual"
        case expectedTurnOver = "ExpectedTurnOver"
        case expectedInvestmentAmount = "ExpectedInvestmentAmount"
        case annualIncome = "AnnualIncome"
        case actionOnBehalfOfOther = "actionOnBehalfOfOther"
        case refusedYourAccount = "refusedYourAccount"
        case seniorPositionInGovtInstitute = "seniorPositionInGovtInstitute"
        case seniorPositionInPoliticalParty = "seniorPositionInPoliticalParty"
        case financiallyDependent = "financiallyDependent"
        case highValueGoldSilverDiamond = "highValueGoldSilverDiamond"
        case incomeIsHighRisk = "incomeIsHighRisk"
        case headOfState = "headOfState"
        case seniorMilitaryOfficer = "seniorMilitaryOfficer"
        case headOfDeptOrIntlOrg = "headOfDeptOrIntlOrg"
        case memberOfBoard = "memberOfBoard"
        case memberOfNationalSenate = "memberOfNationalSenate"
        case politicalPartyOfficials = "politicalPartyOfficials"
        case pep_Declaration = "Pep_Declaration"
        case whereDidYouHearAboutUs = "WhereDidYouHearAboutUs"
        case daoID = "DaoID"
        case cnic = "Cnic"
        case accountType = "AccountType"
        case fundSupporter = "fundSupporter"
    }
}



