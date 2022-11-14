//
//  RiskProfileVC.swift
//  AlMeezan
//
//  Created by Atta khan on 18/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class RiskProfileVC: UIViewController {
    //MARK: Properties
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "5 / 9", titleStr: "Risk Profile", subTitle: "Risk Profile" ,numberOfPages: 0, currentPageNo: 0, closeAction: {
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
    
    private (set) lazy var idealLbl: UILabel = { [unowned self] in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "Your Ideal score is"
        label.numberOfLines = 0
        label.textColor =  UIColor.rgb(red: 25, green: 39, blue: 70, alpha: 1)
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 16)
        return label
    }()
    
    private (set) lazy var scroeLbl: UILabel = { [unowned self] in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "26"
        label.numberOfLines = 0
        label.textColor =  UIColor.init(rgb: 0x8A269B)
        label.font = UIFont(name: AppFontName.circularStdBold, size: 28)
        return label
    }()
    
    private (set) lazy var descLbl: UILabel = { [unowned self] in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.text = "As per your risk profile, we suggest you to select stable portofolio (e.g Income Fund)"
        label.numberOfLines = 0
        label.textColor =  UIColor.lightGray
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        label.textAlignment = .center
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
    
    
    
    private var ageTxt: String                  =   ""
    private var riskReturnToleranceTxt: String  =   ""
    private var monthSavingTxt: String          =   ""
    private var occupationTxt: String           =   ""
    private var investmentObjectiveTxt: String  =   ""
    private var knowledgeOfInvestmentTxt: String =   ""
    private var investmentHorizonTxt: String    =   ""
    
    
    var ageView: TextInputView!
    var riskReturnToleranceView: ButtonPickerView!
    var monthSavingView: ButtonPickerView!
    var occupationView: ButtonPickerView!
    var investmentObjectiveView: ButtonPickerView!
    var knowledgeOfInvestmentView: ButtonPickerView!
    var investmentHorizonView: ButtonPickerView!
    var termsAndConditionView: TermsAndConditionView!
    var dataSource: GenericPickerDataSource<OptionModel>?
    
    var age: [OptionModel] = [OptionModel]()
    var riskReturnTolerance: [OptionModel] = [OptionModel]()
    var monthSaving: [OptionModel] = [OptionModel]()
    var occupation: [OptionModel] = [OptionModel]()
    var investmentObjective: [OptionModel] = [OptionModel]()
    var knowledgeOfInvestment: [OptionModel] = [OptionModel]()
    var investmentHorizon: [OptionModel] = [OptionModel]()
    
    
    // Selected Picker View Items
    var ageItem: Int = 0
    var riskReturnToleranceItem: Int = 0
    var monthSavingItem: Int = 0
    var occupationItem: Int = 0
    var investmentObjectiveItem: Int = 0
    var knowledgeOfInvestmentItem: Int = 0
    var investmentHorizonItem: Int = 0
    
    var isTerms: Bool = false
    var router: RiskProfileRouterProtocol?
    var interactor: RiskProfileInteractor?
    
    var riskProfile: RiskProfile?
    var basicInfo: PersonalInfoEntity.BasicInfo?
    var KYCInfo: KYCModel?
    var factaInfo: FACTAModel?
    var crs: Crs?
    init(factaInfo: FACTAModel?, KYCInfo: KYCModel?, basicInfo: PersonalInfoEntity.BasicInfo?, crs: Crs?) {
        self.factaInfo = factaInfo
        self.KYCInfo = KYCInfo
        self.basicInfo = basicInfo
        self.crs = crs
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        router?.navigationController = navigationController
        
        occupation.append(
            contentsOf: [
                OptionModel(code: "Pension", name: "Retired", isActive: 0),
                OptionModel(code: "Housewife", name: "Housewife/Student", isActive: 0),
                OptionModel(code: "salary", name: "Salaried", isActive: 0),
                OptionModel(code: "Business/Self-employed", name: "Business/Self-employed", isActive: 0)
            ]
        )
        
        
        if let data = Constant.setup_data {
            age = data.age ?? []
            riskReturnTolerance = data.riskTolerence ?? []
            monthSaving = data.monthlySavings ?? []
            
            investmentObjective = data.investmentObjective ?? []
            knowledgeOfInvestment = data.knowledgeOfInvestment ?? []
            investmentHorizon = data.investmentHorizon ?? []
        }
        
        setupViews()
    }

}
extension RiskProfileVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        if self.age.count > 0 {
            self.ageView?.txtField.text = self.age[0].name
        }
        if let info = Constant.CustomerData.customer_data?.cNICData?.riskProfile {
            ageTxt                      =   info.age ?? ""
            riskReturnToleranceTxt      =   info.riskReturn ?? ""
            monthSavingTxt              =   info.monthlySavings ?? ""
            occupationTxt               =   info.occupation ?? ""
            investmentObjectiveTxt      =   info.investmentObjective ?? ""
            knowledgeOfInvestmentTxt    =   info.knowledgeLevel ?? ""
            investmentHorizonTxt        =   info.investmentHorizon ?? ""
            ageItem = age.firstIndex(where: {$0.name == ageTxt}) ?? 0
            riskReturnToleranceItem = riskReturnTolerance.firstIndex(where: {$0.name == riskReturnToleranceTxt}) ?? 0
            monthSavingItem = monthSaving.firstIndex(where: {$0.name == monthSavingTxt}) ?? 0
            occupationItem = occupation.firstIndex(where: {$0.name == occupationTxt}) ?? 0
            investmentObjectiveItem = investmentObjective.firstIndex(where: {$0.name == investmentObjectiveTxt}) ?? 0
            investmentHorizonItem = investmentHorizon.firstIndex(where: {$0.name == investmentHorizonTxt}) ?? 0
            knowledgeOfInvestmentItem = knowledgeOfInvestment.firstIndex(where: {$0.name == knowledgeOfInvestmentTxt}) ?? 0
            
        }
        let Txt = KYCInfo?.sourceOfIncome ?? ""
        occupationItem = occupation.firstIndex(where: {$0.code?.lowercased() == Txt.lowercased()}) ?? 0
        occupationTxt = occupation[occupationItem].name ?? ""

        let ageVal = self.basicInfo?.dateOfBirth?.toDate(withFormat: "yyyy-MM-dd")?.age ?? 40
        
        if ageVal <= 40 {
            ageTxt = age[0].name ?? ""
            ageItem = 0
        } else if 40...50 ~= ageVal {
            ageTxt = age[1].name ?? ""
            ageItem = 1
        } else if 50...60 ~= ageVal {
            ageTxt = age[2].name ?? ""
            ageItem = 2
        }
        else if ageVal > 60 {
            ageTxt = age[3].name ?? ""
            ageItem = 3
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
        
        
        //TextInputView
//        ageView = ButtonPickerView(heading:  "Age", placeholder: "Select Age", image: "down_Arrow") {
//            self.dataSource = GenericPickerDataSource<OptionModel>(
//                withItems: self.age,
//                        withRowTitle: { (data) -> String in
//                            return data.name ?? ""
//                        }, row: self.ageItem,  didSelect: { (data) in
//                            self.ageView?.txtField.text = data.name
//                            self.ageTxt = data.name ?? ""
//                        })
//            self.ageView?.txtField.setupPickerField(withDataSource: self.dataSource!)
//        }
//        ageView.setData(text: ageTxt)
//        stackView.addArrangedSubview(ageView)
        
        
        ageView = TextInputView(heading:  "Age", placeholder: "Enter Age", isPasswordEnable: false) { [weak self] (enteredText) in
            guard let self = self else {return}
            self.ageTxt = enteredText
        }
        ageView.setData(text: ageTxt)
        stackView.addArrangedSubview(ageView)
        ageView.txtField.isUserInteractionEnabled = false
        
        
        
        
        
        
        riskReturnToleranceView = ButtonPickerView(heading:  "Risk-Return Tolerance", placeholder: "Risk-Return Tolerance", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.riskReturnTolerance,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.riskReturnToleranceItem,  didSelect: { (data) in
                            self.riskReturnToleranceView?.txtField.text = data.name
                            self.riskReturnToleranceTxt = data.name ?? ""
                        })
            self.riskReturnToleranceView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        riskReturnToleranceView.setData(text: riskReturnToleranceTxt)
        stackView.addArrangedSubview(riskReturnToleranceView)
        

        monthSavingView = ButtonPickerView(heading:  "Monthly Saving ", placeholder: "Select Monthly Saving", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.monthSaving,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.monthSavingItem,  didSelect: { (data) in
                            self.monthSavingView?.txtField.text = data.name
                            self.monthSavingTxt = data.name ?? ""
                        })
            self.monthSavingView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        monthSavingView.setData(text: monthSavingTxt)
        stackView.addArrangedSubview(monthSavingView)
        
         occupationView = ButtonPickerView(heading:  "Occupation", placeholder: "Select Occupation", image: "down_Arrow") {
             self.dataSource = GenericPickerDataSource<OptionModel>(
                 withItems: self.occupation,
                         withRowTitle: { (data) -> String in
                             return data.name ?? ""
                         }, row: self.occupationItem,  didSelect: { (data) in
                             self.occupationView?.txtField.text = data.name
                             self.occupationTxt = data.name ?? ""
                         })
             self.occupationView?.txtField.setupPickerField(withDataSource: self.dataSource!)
        }
        occupationView.setData(text: occupationTxt)
        stackView.addArrangedSubview(occupationView)
        
        
        
        
        investmentObjectiveView = ButtonPickerView(heading:  "Investment Objective", placeholder: "Select Investment Objective", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.investmentObjective,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.investmentObjectiveItem,   didSelect: { (data) in
                            self.investmentObjectiveView?.txtField.text = data.name
                            self.investmentObjectiveTxt = data.name ?? ""
                        })
            self.investmentObjectiveView?.txtField.setupPickerField(withDataSource: self.dataSource!)
       }
        investmentObjectiveView.setData(text: investmentObjectiveTxt)
       stackView.addArrangedSubview(investmentObjectiveView)
        
        
        
        
        knowledgeOfInvestmentView = ButtonPickerView(heading:  "Knowledge of Investment", placeholder: "Select Knowledge of Investment", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.knowledgeOfInvestment,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.knowledgeOfInvestmentItem,  didSelect: { (data) in
                            self.knowledgeOfInvestmentView?.txtField.text = data.name
                            self.knowledgeOfInvestmentTxt = data.name ?? ""
                        })
            self.knowledgeOfInvestmentView?.txtField.setupPickerField(withDataSource: self.dataSource!)
       }
        knowledgeOfInvestmentView.setData(text: knowledgeOfInvestmentTxt)
        stackView.addArrangedSubview(knowledgeOfInvestmentView)
        
        
        
        
        investmentHorizonView = ButtonPickerView(heading:  "Investment Horizon", placeholder: "Select Investment Horizon", image: "down_Arrow") {
            self.dataSource = GenericPickerDataSource<OptionModel>(
                withItems: self.investmentHorizon,
                        withRowTitle: { (data) -> String in
                            return data.name ?? ""
                        }, row: self.investmentHorizonItem,  didSelect: { (data) in
                            self.investmentHorizonView?.txtField.text = data.name
                            self.investmentHorizonTxt = data.name ?? ""
                        })
            self.investmentHorizonView?.txtField.setupPickerField(withDataSource: self.dataSource!)
       }
        investmentHorizonView.setData(text: investmentHorizonTxt)
       stackView.addArrangedSubview(investmentHorizonView)

        termsAndConditionView = TermsAndConditionView(heading: "I understand and agree that Al Meezan Investment Management Limited (Al Meezan) has suggested me a specific fund category as per my risk profile. However, I reserve the discretion to invest in any other fund category. I confirm that I am aware of associated risks with investment in this fund category and confirm that I will not hold Al Meezan responsible for any loss which may occur as a result of my decision. I further confirm that I have read the Trust Deeds, Offering Documents, Supplemental Trust Deeds and Supplemental Offering Documents that govern these Investment/Conversion transactions.", selectedCheckboxCloser: { isSelect in
            self.isTerms = isSelect
        })
        stackView.addArrangedSubview(termsAndConditionView)
        let btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            if self.ageTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter age.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.riskReturnToleranceTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter risk return tolerance.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            if self.monthSavingTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter monthly saving.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            if self.occupationTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter occupation.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.investmentObjectiveTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter investment objective.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.knowledgeOfInvestmentTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter knowledge of investment.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            if self.investmentHorizonTxt == ""{
                self.showAlert(title: "Alert", message: "Please enter investment horizon.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            let age = self.basicInfo?.dateOfBirth?.toDate(withFormat: "yyyy-MM-dd")?.age ?? 60
            
            if self.isTerms == false {
                self.showAlert(title: "Alert", message: "Please Check Terms and Conditions.", controller: self) {
                    //self.nameView.txt.becomeFirstResponder()
                }
                return
            }
            
            
            let info = RiskProfile(
                                   KeyValueValue: "",
                                   ageInYears: age,
                                   age: self.ageTxt,
                                   riskReturn: self.riskReturnToleranceTxt,
                                   monthlySavings: self.monthSavingTxt,
                                   occupation: self.occupationTxt,
                                   investmentObjective: self.investmentObjectiveTxt,
                                   knowledgeLevel: self.knowledgeOfInvestmentTxt,
                                   investmentHorizon: self.investmentHorizonTxt,
                                   idealPortfolio: "",
                                   idealFund: "",
                                   idealScore: "",
                                   cnic: "",
                                   accountType: "BOTH")
            self.riskProfile = info
            self.interactor?.riskCalculation(age: self.ageTxt, ageYear: age, riskReturn: self.riskReturnToleranceTxt, monthlySaving: self.monthSavingTxt, occupaiton: self.occupationTxt, investmentObjective: self.investmentObjectiveTxt, knowledgeLevel: self.knowledgeOfInvestmentTxt, investmentHorizon: self.investmentHorizonTxt)
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
        popupView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        popupView.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 20).isActive = true
        
        if !scroeLbl.isDescendant(of: self.popupView) {
            popupView.addSubview(scroeLbl)
        }
        
        scroeLbl.centerYAnchor.constraint(equalTo: self.popupView.centerYAnchor).isActive = true
        scroeLbl.centerXAnchor.constraint(equalTo: self.popupView.centerXAnchor).isActive = true
        
        
        if !idealLbl.isDescendant(of: self.popupView) {
            popupView.addSubview(idealLbl)
        }
        idealLbl.bottomAnchor.constraint(equalTo: self.scroeLbl.topAnchor, constant: -20).isActive = true
        idealLbl.centerXAnchor.constraint(equalTo: self.popupView.centerXAnchor).isActive = true
        
        
        
        if !descLbl.isDescendant(of: self.popupView) {
            popupView.addSubview(descLbl)
        }
        descLbl.topAnchor.constraint(equalTo: self.scroeLbl.bottomAnchor, constant: 20).isActive = true
        descLbl.centerXAnchor.constraint(equalTo: self.popupView.centerXAnchor).isActive = true
        descLbl.leadingAnchor.constraint(equalTo: self.popupView.leadingAnchor, constant: 20).isActive = true
        if !closeBtn.isDescendant(of: self.popupView) {
            popupView.addSubview(closeBtn)
        }
        closeBtn.topAnchor.constraint(equalTo: self.popupView.topAnchor, constant: 16).isActive = true
        closeBtn.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -20).isActive = true
        
        
        
        blurView.isHidden = true
        popupView.isHidden = true
    }
    
    @objc private func didTapCloseBtn(_ sender: UIButton) {
        blurView.isHidden = true
        popupView.isHidden = true
        showLoader()
        self.interactor?.saveData(basicInfo: nil, healthDec: nil, kyc: nil, fatca: nil, crs: nil, riskProfile: self.riskProfile)



        Constant.SSA_data = SSACNICData(basicInfo: self.basicInfo, healthDec: Constant.health_dec, kyc: self.KYCInfo, fatca: self.factaInfo, crs: self.crs, riskProfile: self.riskProfile)
        
        
        
    }
    
}
extension RiskProfileVC: RiskProfileViewProtocol {
    func getSuccessdata(response: RiskProfileEntity.RiskProfileResponseModel) {
        DispatchQueue.main.async {
            self.hideLoader()
            self.blurView.isHidden = false
            self.popupView.isHidden = false
            self.scroeLbl.text = String("\(response.idealScore ?? 0)")
            if let desc = response.description?.components(separatedBy: "\n") {
                self.descLbl.text = desc[1]
            }
            self.riskProfile?.accountType = self.basicInfo?.accountType
            self.riskProfile?.cnic = self.basicInfo?.cnic
            self.riskProfile?.idealScore = String("\(response.idealScore ?? 0)")
            self.riskProfile?.idealFund = response.idealFund
            self.riskProfile?.idealPortfolio = response.description
            if self.investmentObjectiveTxt == "Monthly Income" {
                UserDefaults.standard.set(self.investmentObjectiveTxt, forKey: "idealFund")
            } else {
                UserDefaults.standard.set(response.idealFund, forKey: "idealFund")
            }
            
        }
    }
    
    func failureData() {
        hideLoader()
    }
    
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response[0].errID == "00" {
            DispatchQueue.main.async {
                self.hideLoader()
                if let message = response[0].errMsg {
                    let vc =  DocumentUploadVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }
    }
}
