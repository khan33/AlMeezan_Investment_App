//
//  HealthDeclarationVC.swift
//  AlMeezan
//
//  Created by Atta khan on 31/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class HealthDeclarationVC: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "2 / 3", titleStr: "Basic Information", subTitle: "Pension Fund", numberOfPages: 3, currentPageNo: 0, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            nextController()
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
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 91, green: 95, blue: 120, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 18)
        label.text = "Pension Fund Account"
        return label
    }()
    
    private (set) lazy var healthLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 91, green: 95, blue: 120, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 18)
        label.text = "Health Declaration"
        return label
    }()
    
    private (set) lazy var lblAllocationplan: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 138, green: 38, blue: 155, alpha: 1)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 12)
        label.attributedText = NSAttributedString(string: "Get details of allocation plan here", attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        return label
    }()
    var allocationSchemeView: ButtonPickerView!
    var retirementAgeView: ButtonPickerView!
    var presentOccupicationView: ButtonPickerView!
    private var allocationSchemeCodeTxt : String = ""
    private var allocationSchemeTxt : String = ""
    private var retirementAgeTxt: String  =   ""
    private var personalPhysicianTxt: String = ""
    private var employerPhoneNumberTxt: String = ""
    private var presentOccupicationTxt: String = ""
    private var investmentAmountTxt: String = ""
    private var currentWeightTxt: String = ""
    private var heightTxt: String = ""

    var presentOccupication: [OptionModel] = [OptionModel]()
    var retirementAge: [OptionModel] = [OptionModel]()
    var dataSource: GenericPickerDataSource<OptionModel>?
    var allocationScheme: [OptionModel] = [OptionModel]()
    
    
    // Selected Picker View Items
    var retirementAgeItem: Int = 0
    var presentOccupicationItem: Int = 0
    var allocationSchemeItem: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblAllocationplan.isUserInteractionEnabled = true
        retirementAge.append(
            contentsOf: [
                OptionModel(code: "", name: "60", isActive: 0),
                OptionModel(code: "", name: "61", isActive: 0),
                OptionModel(code: "", name: "62", isActive: 0),
                OptionModel(code: "", name: "63", isActive: 0),
                OptionModel(code: "", name: "64", isActive: 0),
                OptionModel(code: "", name: "65", isActive: 0),
                OptionModel(code: "", name: "66", isActive: 0),
                OptionModel(code: "", name: "67", isActive: 0),
                OptionModel(code: "", name: "68", isActive: 0),
                OptionModel(code: "", name: "69", isActive: 0),
                OptionModel(code: "", name: "70", isActive: 0)
            ]
        )
        presentOccupication.append(
            contentsOf: [
                OptionModel(code: "", name: "GOVERNMENT EMPLOYMENT", isActive: 0),
                OptionModel(code: "", name: "PRIVATE EMPLOYMENT", isActive: 0),
                OptionModel(code: "", name: "SELF EMPLOYMENT", isActive: 0),
                OptionModel(code: "", name: "AGRICULTURIST", isActive: 0),
                OptionModel(code: "", name: "LANDLORD", isActive: 0),
                OptionModel(code: "", name: "RETIRED", isActive: 0),
                OptionModel(code: "", name: "HOUSEWIFE", isActive: 0),
                OptionModel(code: "", name: "STUDENT", isActive: 0),
                OptionModel(code: "", name: "UNEMPLOYED", isActive: 0),
                OptionModel(code: "", name: "OTHERS", isActive: 0)
            ]
        )
        retirementAgeTxt = "60"
        presentOccupicationTxt = "Government Employment"
        if let data = Constant.setup_data {
            allocationScheme = data.allocationScheme ?? []
            if allocationScheme.count > 0 {
                allocationSchemeItem = 2
                allocationSchemeTxt = allocationScheme[2].name ?? ""
                allocationSchemeCodeTxt = allocationScheme[2].code ?? ""
            }
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(didtapOnLbl))
        lblAllocationplan.addGestureRecognizer(tap)
        
        setupViews()
    }
    
    @objc func didtapOnLbl(sender: UITapGestureRecognizer) {
        let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.urlStr = ALLOCATION_SCHEME
        vc.titleStr = "Allocation Scheme(s) Guideline"
        navigationController?.pushViewController(vc, animated: true)
    }

}
extension HealthDeclarationVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        
        if let info = Constant.CustomerData.customer_data?.cNICData?.healthDec {
            self.retirementAgeTxt = String("\(info.pension?.expectedRetirementAge ?? 60)")
            self.allocationSchemeCodeTxt = info.pension?.allocationScheme ?? ""
//            let scheme = allocationScheme.filter{ $0.code == info.pension?.allocationScheme }
            self.allocationSchemeTxt = info.pension?.allocationScheme ?? ""
            self.personalPhysicianTxt = info.pension?.personalPhysicianName ?? ""
            self.presentOccupicationTxt = info.pension?.presentOccupation ?? ""
            self.investmentAmountTxt = String("\(info.pension?.investmentAmount ?? 0)")
            self.currentWeightTxt = String("\(info.pension?.weight ?? 0)")
            self.heightTxt = String("\(info.pension?.height ?? 0)")
            self.employerPhoneNumberTxt = info.pension?.employersPhoneNo ?? ""
            
            allocationSchemeItem = allocationScheme.firstIndex(where: { $0.name == allocationSchemeTxt }) ?? 0
            retirementAgeItem = retirementAge.firstIndex(where: { $0.name == retirementAgeTxt}) ?? 0
            presentOccupicationItem = presentOccupication.firstIndex(where:  { $0.name?.lowercased() == presentOccupicationTxt.lowercased()} ) ?? 0
            
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
        
        stackView.addArrangedSubview(lblTitle)
        
        retirementAgeView = ButtonPickerView(heading:  "Expected Retirement Age", placeholder: "Select Expected Retirement Age", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.retirementAge,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.retirementAgeItem,  didSelect: { (data) in
                            self.retirementAgeView?.txtField.text = data.name
                            self.retirementAgeTxt = data.name ?? ""
                        })
            self.retirementAgeView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        retirementAgeView.setData(text: retirementAgeTxt)
        stackView.addArrangedSubview(retirementAgeView)
        
        allocationSchemeView = ButtonPickerView(heading:  "Allocation Scheme", placeholder: "Select Allocation Scheme", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.allocationScheme,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.allocationSchemeItem,  didSelect: { (data) in
                            self.allocationSchemeView?.txtField.text = data.name
                            self.allocationSchemeTxt = data.name ?? ""
                            self.allocationSchemeCodeTxt = data.code ?? ""
                        })
            self.allocationSchemeView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        allocationSchemeView.setData(text: allocationSchemeTxt)
        stackView.addArrangedSubview(allocationSchemeView)
        lblAllocationplan.textAlignment = .right
        stackView.addArrangedSubview(lblAllocationplan)
        
        
        
        
        
        let investmentAmountView = CurrencyInputView(heading:  "Investment Amount (Min Rs. 1000 For Pension Fund Account)", placeholder: "Enter Investment Amount", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            let txt = enteredText
            self.investmentAmountTxt = txt.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal)
        }
        investmentAmountView.setData(text: investmentAmountTxt)
        investmentAmountView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(investmentAmountView)
        
        presentOccupicationView = ButtonPickerView(heading:  "Present Occupation", placeholder: "Select Present Occupation", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.presentOccupication,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.presentOccupicationItem,  didSelect: { (data) in
                            self.presentOccupicationView?.txtField.text = data.name
                            self.presentOccupicationTxt = data.name ?? ""
                        })
            self.presentOccupicationView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        presentOccupicationView.setData(text: presentOccupicationTxt)
        stackView.addArrangedSubview(presentOccupicationView)
        //Get details of allocation plan here
        
        
        
        
        
        stackView.addArrangedSubview(healthLbl)
        
        
        
        let personalPhysicianView = TextInputView(heading:  AppString.Heading.physicianName, placeholder: "Enter Personal Physician", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.personalPhysicianTxt = enteredText
        }
        personalPhysicianView.setData(text: personalPhysicianTxt)
        stackView.addArrangedSubview(personalPhysicianView)

        
        let employerPhoneNumberView = TextInputView(heading:  AppString.Heading.employeePhoneNo, placeholder: "Enter Employer's Phone Number", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.employerPhoneNumberTxt = enteredText
        }
        employerPhoneNumberView.setData(text: employerPhoneNumberTxt)
        employerPhoneNumberView.txtField.keyboardType = .asciiCapableNumberPad
        stackView.addArrangedSubview(employerPhoneNumberView)
        
        
        
        
        
        
       
        
        
        
        let currentWeightView = TextInputView(heading:  "Current Weight (Kg)", placeholder: "Enter Current Weight", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.currentWeightTxt = enteredText
        }
        currentWeightView.setData(text: currentWeightTxt)
        currentWeightView.txtField.keyboardType = .decimalPad
        stackView.addArrangedSubview(currentWeightView)
        
        
        let heightView = TextInputView(heading:  "Height (Ft)", placeholder: "Enter Height (Ft)", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.heightTxt = enteredText
        }
        heightView.setData(text: heightTxt)
        heightView.txtField.keyboardType = .decimalPad
        stackView.addArrangedSubview(heightView)
        
        
        
        
        
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            
            self.nextController()
            
        }
        
        stackView.addArrangedSubview(btnView)
        
    }
    
    func nextController() {
        if self.retirementAgeTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter retirement age.", controller: self) {
            }
            return
        }


        if self.allocationSchemeTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter allocation scheme.", controller: self) {
            }
            return
        }
        
        
        if self.investmentAmountTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter investment amount.", controller: self) {
            }
            return
        }
        if let amount = Int(self.investmentAmountTxt) {
            if amount < 1000 {
                self.showAlert(title: "Alert", message: "Please enter amount at least Rs. 1000/-", controller: self) {
                }
                return
            }
            if let chanel = UserDefaults.standard.string(forKey: "OnlineAccountType") {
                if chanel == "SSA" {
                    if amount > 400000 {
                    self.showAlert(title: "Alert", message: "Maximum initial investment amount for VPS should be Rs. 400,000/-.", controller: self) {
                    }
                    return
                    }
                }
            }
            
        }
        if self.presentOccupicationTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter present occupication.", controller: self) {
            }
            return
        }

//            if self.personalPhysicianTxt == "" {
//                self.showAlert(title: "Alert", message: "Please enter personal physician name and address.", controller: self) {
//                }
//                return
//            }
        
        if self.employerPhoneNumberTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter phone number.", controller: self) {
            }
            return
        }
        
        
        
        
        
        if self.currentWeightTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your current weight.", controller: self) {

            }
            return
        }
        if self.heightTxt == "" {
            self.showAlert(title: "Alert", message: "Please enter your current height.", controller: self) {

            }
            return
        }
        let accountType = UserDefaults.standard.string(forKey: "accountType") ?? "BOTH"
        let cnic = UserDefaults.standard.string(forKey: "CNIC") ?? ""
        let info = Pension1(expectedRetirementAge: Int(self.retirementAgeTxt), allocationScheme: self.allocationSchemeCodeTxt, personalPhysicianName: self.personalPhysicianTxt, employersPhoneNo: self.employerPhoneNumberTxt, presentOccupation: self.presentOccupicationTxt, investmentAmount: self.investmentAmountTxt.doubleValue, weight: self.currentWeightTxt.doubleValue, height: self.heightTxt.doubleValue, cnic: cnic, accountType: accountType)
        let vc = HealthQuestionaireVC(pension: info)
        HealthQuestionaireConfigurator.configureModule(viewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
