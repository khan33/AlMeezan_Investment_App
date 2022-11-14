//
//  HealthQuestionaireVC.swift
//  AlMeezan
//
//  Created by Atta khan on 06/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class HealthQuestionaireVC: UIViewController {
    
// MARK: - PROPERTIES
    
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "3 / 3", titleStr: "Basic Information", subTitle: "Questionnaire" ,numberOfPages: 0, currentPageNo: 0, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            submitNextQuestion(isNext: true)
        }, previousAction: {
            submitNextQuestion(isNext: false)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private (set) lazy var questionNo: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Q1"
        label.textColor =  UIColor.init(rgb:0xB9BBC6)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 20)
        return label
    }()
    
    private (set) lazy var questionLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Have you ever had or been diagnosed with any of the following."
        label.textColor =  UIColor.black
        label.font = UIFont(name: AppFontName.robotoRegular, size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private (set) lazy var collectionView: UICollectionView = { [unowned self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.estimatedItemSize = CGSize.zero
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
//        collectionView.backgroundColor = UIColor.red
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QuestionViewCell.self, forCellWithReuseIdentifier: "QuestionViewCell")
        return collectionView;
    }()
    
    private (set) lazy var QuestionNoCollectionView: UICollectionView = { [unowned self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.estimatedItemSize = CGSize.zero
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        
//        collectionView.backgroundColor = UIColor.init(rgb: 0xE2E2E2)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QuestionNoViewCell.self, forCellWithReuseIdentifier: "QuestionNoViewCell")
        collectionView.register(OtherViewCell.self, forCellWithReuseIdentifier: "OtherViewCell")
        return collectionView;
    }()
    
    private (set) lazy var lineView: UIView = { [unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(rgb: 0xE2E2E2)
        return view
    }()
    var totalQuestion = 9
    var questionIndex = 0
    var btnView: CenterButtonView!
    var router: HealthQuestionaireRouterProtocol?
    var interactor: BasicInfoInteractorProtoocl?
    
    var quesitons: HealthQuestionnaire?
    var covidQuesitons: HealthQuestionnaire?
    var q : [OptionModel]?
    
    
    var everDiagnosedInfo: EverDiagnosedWith?
    var takingMedicationInfo: TakingMedication?
    var diedOrSufferedBeforeInfo: DiedOrSufferedBefore60?
    var lifeInsuranceInfo: LifeInsurance?
    var doYouSmokeInfo: DoYouSmoke?
    var drinkAlcoholInfo: DrinkAlcohol?
    var drugsOtherThanDrInfo: DrugsOtherThanDr?
    var hazardourPursuitsInfo: HazardourPursuits?
    var foriegnTravelInfo: ForiegnTravel?
    var takaFulQuestionInfo : TakafulQues?
    var covidQuesitonOpitons: Covid19Ques?
    
    var questionaireType: String = "health"
    var fever : Int = 0
    var soreThroat : Int = 0
    var dryCough : Int = 0
    var bodyAche : Int = 0
    var headAche : Int = 0
    var shortnessOfBreath : Int = 0
    var fatigue : Int = 0
    var lossOfTaste : Int = 0
    var lossOfSmell : Int = 0
    var covid19Tested : Int  = 0
    var inCasePositiveResultCompleteRecovery : Int  = 0
    var past14ContactedWithAnyOne : Int = 0
    var noticeIssueForSelfQuarantine : Int = 0
    var stayOutsideCountryOrReturned : Int = 0
    var nextThreeMonthsTravel : Int = 0
    
    var everDiagnosedWithTxt: String = ""
    var takingMedicationTxt: String = ""
    var DiedOrSufferedBefore60Txt: String = ""
    var LifeInsuranceTxt: String = ""
    var DoYouSmokeTxt: String = ""
    var DrinkAlcoholTxt: String = ""
    var DrugsOtherThanDrTxt: String = ""
    var HazardourPursuitsTxt: String = ""
    var ForiegnTravelTxt: String = ""
    var anyoneIfYesCovidTxt: String = ""
    var dateOfTestTxt: String = "1900-01-01T00:00:00"
    var resultOfTestTxt: String = ""
    var stayOutSideCountryIfYesDetailsTxt = ""
    var nextThreeMonthIfYesDetailsTxt = ""
    
    var q1TxtField = OptionModel(code: "other", name: "If so, please give details (date, duration, treatment, name/address of physicians).", isActive: 0)
    var q2TxtField = OptionModel(code: "other", name: "If so, please give full particulars.", isActive: 0)
    var q3TxtField = OptionModel(code: "other", name: "If so, please give details (age if living, present state of health, age/cause of death).", isActive: 0)
    var q4TxtField = OptionModel(code: "other", name: "If so, please give details (sum assured, duration, reason for loading, policy interest).", isActive: 0)
    var q5TxtField = OptionModel(code: "other", name: "If so, please state your normal daily consumption of cigarettes, cigarillos, cigars or pipe.", isActive: 0)
    var q6TxtField = OptionModel(code: "other", name: "If so, what is your normal weekly consumption of alcohol (please state also whether beer, wine or spirits).", isActive: 0)
    var q7TxtField = OptionModel(code: "other", name: "If so, please give details (date, duration, type of drugs) on the back signed by yourself.", isActive: 0)
    var q8TxtField = OptionModel(code: "other", name: "If so, please give details (e.g. diving depth, type of vehicle, type of aircraft).", isActive: 0)
    var q9TxtField = OptionModel(code: "other", name: "If so, please give details (e.g. exact type of hazard, name/region of the country).", isActive: 0)
    
    
    var covid1Question = OptionModel(code: "other", name: "If the answer to any of the above is yes, please provide further details i.e. since when do you have the symptoms, duration of symptoms, any treatment taken yet, lab test results (if any), name and address of treating doctor/clinic/hospital.", isActive: 0)
    
    var covid2Question = OptionModel(code: "other", name: "If yes, please provide information: Country / City / Departure Date / Arrived Date / Planned return date.", isActive: 0)
    var covid3Question = OptionModel(code: "other", name: "If yes, please provide information: Country / City / Date of Travel / Intended Duration.", isActive: 0)
    
    var covidTestQuestion = OptionModel(code: "covid", name: "Date of the test", isActive: 0)
    
    var covid4Question = OptionModel(code: "other", name: "If yes, please provide information: Country / City / Departure Date / Arrived Date / Planned return date.", isActive: 0, textFieldRequired: false)
  
    
    
    
    var questionOtherTxt: String = ""
    var isCovid: Bool = false
    var newQuestion: [[OptionModel]] = [[OptionModel]]()

    var pension: Pension1
    init(pension: Pension1) {
        self.pension = pension
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
// MARK: - CONTROLLER LIFE CYCEL
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = Constant.setup_data {
            quesitons = data.healthQuestionnaire
            covidQuesitons = data.covid19Questionnaire
            if let info = Constant.CustomerData.customer_data?.cNICData?.healthDec?.takafulQues {
                quesitons?.q1?[0].answer = info.everDiagnosedWith?.highBloodPressure ?? 0
                quesitons?.q1?[1].answer = info.everDiagnosedWith?.cancerTumor ?? 0
                quesitons?.q1?[2].answer = info.everDiagnosedWith?.diabetes ?? 0
                quesitons?.q1?[3].answer = info.everDiagnosedWith?.disorderOfStomach ?? 0
                quesitons?.q1?[4].answer = info.everDiagnosedWith?.disorderOfJoints ?? 0
                quesitons?.q1?[5].answer = info.everDiagnosedWith?.asthama ?? 0
                quesitons?.q1?[6].answer = info.everDiagnosedWith?.headache ?? 0
                quesitons?.q1?[7].answer = info.everDiagnosedWith?.other ?? 0
                everDiagnosedWithTxt = info.everDiagnosedWith?.answer ?? ""
                quesitons?.q2?[0].answer = info.takingMedication?.medication ?? 0
                quesitons?.q2?[1].answer = info.takingMedication?.advisedOrTreated ?? 0
                takingMedicationTxt = info.takingMedication?.answer ?? ""
                quesitons?.q3?[0].answer = info.diedOrSufferedBefore60?.answer ?? 0
                DiedOrSufferedBefore60Txt = info.diedOrSufferedBefore60?.explaination ?? ""
                quesitons?.q4?[0].answer = info.lifeInsurance?.accidentalDeath ?? 0
                quesitons?.q4?[1].answer = info.lifeInsurance?.coverWithAnotherCompany ?? 0
                quesitons?.q4?[2].answer = info.lifeInsurance?.coveredDeclined ?? 0
                LifeInsuranceTxt = info.lifeInsurance?.answer ?? ""
                quesitons?.q5?[0].answer = info.doYouSmoke?.answer ?? 0
                DoYouSmokeTxt = info.doYouSmoke?.explaination ?? ""
                quesitons?.q6?[0].answer = info.drinkAlcohol?.answer ?? 0
                DrinkAlcoholTxt = info.drinkAlcohol?.explaination ?? ""
                quesitons?.q7?[0].answer = info.drugsOtherThanDr?.answer ?? 0
                DrugsOtherThanDrTxt = info.drugsOtherThanDr?.explaination ?? ""
                quesitons?.q8?[0].answer = info.hazardourPursuits?.answer ?? 0
                HazardourPursuitsTxt = info.hazardourPursuits?.explaination ?? ""
                quesitons?.q9?[0].answer = info.foriegnTravel?.answer ?? 0
                ForiegnTravelTxt = info.foriegnTravel?.explaination ?? ""
                
                
                    
        
                
            }
            if let info = Constant.CustomerData.customer_data?.cNICData?.healthDec?.covid19Ques {
                covidQuesitons?.q1?[0].answer = info.fever ?? 0
                covidQuesitons?.q2?[0].answer = info.soreThroat ?? 0
                covidQuesitons?.q3?[0].answer = info.dryCough ?? 0
                covidQuesitons?.q4?[0].answer = info.bodyAche ?? 0
                covidQuesitons?.q5?[0].answer = info.headAche ?? 0
                covidQuesitons?.q6?[0].answer = info.shortnessOfBreath ?? 0
                covidQuesitons?.q7?[0].answer = info.fatigue ?? 0
                covidQuesitons?.q8?[0].answer = info.lossOfTaste ?? 0
                covidQuesitons?.q9?[0].answer = info.lossOfSmell ?? 0
                covidQuesitons?.q10?[0].answer = info.covid19Tested ?? 0
                covidQuesitons?.q11?[0].answer = info.inCasePositiveResultCompleteRecovery ?? 0
                covidQuesitons?.q12?[0].answer = info.past14ContactedWithAnyOne ?? 0
                covidQuesitons?.q13?[0].answer = info.noticeIssueForSelfQuarantine ?? 0
                covidQuesitons?.q14?[0].answer = info.stayOutsideCountryOrReturned ?? 0
                covidQuesitons?.q15?[0].answer = info.nextThreeMonthsTravel ?? 0
                
                anyoneIfYesCovidTxt = info.anyoneIfYesFurtherDetails ?? ""
                dateOfTestTxt = info.dateOfTest ?? ""
                resultOfTestTxt = info.resultOfTest ?? ""
                stayOutSideCountryIfYesDetailsTxt = info.stayOutSideCountryIfYesDetails ?? ""
                nextThreeMonthIfYesDetailsTxt = info.nextThreeMonthIfYesDetails ?? ""
                if dateOfTestTxt != "" {
                    isCovid = true
                }
                
            }
            
            if let question = data.healthQuestionnaire,
                var q1 = question.q1, var q2 = question.q2, var q3 = question.q3, var q4 = question.q4, var q5 = question.q5, var q6 = question.q6, var q7 = question.q7, var q8 = question.q8, var q9 = question.q9,
               let covid = data.covid19Questionnaire,
               var q10 = covid.q1, var q11 = covid.q10, var q12 = covid.q11, var q13 = covid.q12, var q14 = covid.q13, var q15 = covid.q14, var q16 = covid.q15
            {
                q1TxtField.explaination = everDiagnosedWithTxt
                q2TxtField.explaination = takingMedicationTxt
                q3TxtField.explaination = DiedOrSufferedBefore60Txt
                q4TxtField.explaination = LifeInsuranceTxt
                q5TxtField.explaination = DoYouSmokeTxt
                q6TxtField.explaination = DrinkAlcoholTxt
                q7TxtField.explaination = DrugsOtherThanDrTxt
                q8TxtField.explaination = HazardourPursuitsTxt
                q9TxtField.explaination = ForiegnTravelTxt
                covid1Question.explaination = anyoneIfYesCovidTxt
                covid2Question.explaination = stayOutSideCountryIfYesDetailsTxt
                covid3Question.explaination = nextThreeMonthIfYesDetailsTxt
                covidTestQuestion.explaination = "\(dateOfTestTxt),\(resultOfTestTxt)"
                
                q1.append(q1TxtField)
                q2.append(q2TxtField)
                q3.append(q3TxtField)
                q4.append(q4TxtField)
                q5.append(q5TxtField)
                q6.append(q6TxtField)
                q7.append(q7TxtField)
                q8.append(q8TxtField)
                q9.append(q9TxtField)
                
                q10.append(covid1Question)
                q11.append(covidTestQuestion)
                q12.append(covid4Question)
                q13.append(covid4Question)
                q14.append(covid4Question)
                q15.append(covid2Question)
                q16.append(covid3Question)
                
                
                newQuestion.append(
                    contentsOf:[
                        q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15, q16
                    ]
                )
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(covidDatePicker), name: Notification.Name(rawValue: "date Picker"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(covidTestResult), name: Notification.Name(rawValue: "result"), object: nil)
        setupViews()
        questionLbl.text = quesitons?.question1
        
    }
    
    
    @objc func covidTestResult(_ notification: NSNotification) {
        if let dic = notification.userInfo as NSDictionary? {
            if let result = dic["result"] as? String {
                resultOfTestTxt = result
            }
        }
    }
    
    @objc func covidDatePicker(_ notification: NSNotification) {
        if let dic = notification.userInfo as NSDictionary? {
            if let date = dic["picker"] as? String {
                isCovid = true
                dateOfTestTxt = date
            }
        }
    }
    
    
}
extension HealthQuestionaireVC {
    fileprivate func setupViews() {
        self.view.backgroundColor = .white
        
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 124.0).isActive = true
        
        if !lineView.isDescendant(of: self.view) {
            self.view.addSubview(lineView)
        }
        lineView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        if !QuestionNoCollectionView.isDescendant(of: self.view) {
            self.view.addSubview(QuestionNoCollectionView)
        }
//        QuestionNoCollectionView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: -1).isActive = true
        QuestionNoCollectionView.centerYAnchor.constraint(equalTo: self.lineView.centerYAnchor).isActive = true
        QuestionNoCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        QuestionNoCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        QuestionNoCollectionView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        if !questionNo.isDescendant(of: self.view) {
            self.view.addSubview(questionNo)
        }
        questionNo.topAnchor.constraint(equalTo: QuestionNoCollectionView.bottomAnchor, constant: 16).isActive = true
        questionNo.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        questionNo.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        if !questionLbl.isDescendant(of: self.view) {
            self.view.addSubview(questionLbl)
        }
        questionLbl.topAnchor.constraint(equalTo: questionNo.bottomAnchor, constant: 16).isActive = true
        questionLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        questionLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        
        
        if !collectionView.isDescendant(of: self.view) {
            self.view.addSubview(collectionView)
        }
        collectionView.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 16).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true

        
        btnView = CenterButtonView.init(title: AppString.Heading.savebtn) { [weak self] (clicked) in
            guard let self = self else {return}
            self.submitNextQuestion(isNext: true)
        }
        self.view.addSubview(btnView)
        btnView.translatesAutoresizingMaskIntoConstraints = false
        btnView.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 16).isActive = true
        btnView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16).isActive = true
        btnView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        btnView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        btnView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
//        if everDiagnosedWithTxt != "" || takingMedicationTxt != "" || LifeInsuranceTxt != "" || DoYouSmokeTxt != "" || DrinkAlcoholTxt != "" || DrugsOtherThanDrTxt != "" || HazardourPursuitsTxt != "" || ForiegnTravelTxt != "" || DiedOrSufferedBefore60Txt != "" {
//            let indexPath = IndexPath(item: questionIndex, section: 0)
//            let cell = collectionView.cellForItem(at: indexPath) as? QuestionViewCell
//            cell?.collectionViewItems.scrollToBottom()
//        }
    }
    
    private func reload() {
        questionIndex = questionIndex + 1
        questionOtherTxt = ""
        self.QuestionNoCollectionView.reloadData()
        self.collectionView.reloadData()
    }
    
    private func checkCovidTxtValidation() -> Bool {
        let filter = newQuestion[questionIndex].filter({ $0.answer == 1 })
        if isCovid == false && filter.count > 0 {
            self.showAlert(title: "Alert", message: "Select covid test date", controller: self) {
            }
            return false
        }
        return true
    }
    
    private func checkTxtValidation() -> Bool {
        let filter = newQuestion[questionIndex].filter({ $0.answer == 1 })
        if self.questionOtherTxt == "" && filter.count > 0 {
            self.showAlert(title: "Alert", message: "Fill required field.", controller: self) {
            }
            return false
        }
        return true
    }
    
    
    private func submitNextQuestion(isNext: Bool = true) {
        
        if isNext {
            if newQuestion.count > questionIndex {
                if questionIndex == 0 {
                    if checkTxtValidation() {
                        self.everDiagnosedWithTxt = self.questionOtherTxt
                        self.everDiagnosedInfo = EverDiagnosedWith(
                            highBloodPressure: newQuestion[questionIndex][0].answer,
                            cancerTumor: newQuestion[questionIndex][1].answer,
                            diabetes: newQuestion[questionIndex][2].answer,
                            disorderOfStomach: newQuestion[questionIndex][3].answer,
                            disorderOfJoints: newQuestion[questionIndex][4].answer,
                            asthama: newQuestion[questionIndex][5].answer,
                            headache: newQuestion[questionIndex][6].answer,
                            other: newQuestion[questionIndex][7].answer,
                            answer: everDiagnosedWithTxt
                        )
                        reload()
                    }
                }
                else if questionIndex == 1 {
                    if checkTxtValidation() {
                        self.takingMedicationTxt = self.questionOtherTxt
                        self.takingMedicationInfo = TakingMedication(
                            medication: newQuestion[questionIndex][0].answer,
                            advisedOrTreated: newQuestion[questionIndex][1].answer,
                            answer: self.takingMedicationTxt
                        )
                        reload()
                    }
                }
                
                else if questionIndex == 2 {
                    if checkTxtValidation() {
                        self.DiedOrSufferedBefore60Txt = self.questionOtherTxt
                        self.diedOrSufferedBeforeInfo = DiedOrSufferedBefore60 (answer: newQuestion[questionIndex][0].answer, explaination: self.DiedOrSufferedBefore60Txt)
                        reload()
                    }
                }
                else if questionIndex == 3 {
                    if checkTxtValidation() {
                        self.LifeInsuranceTxt = self.questionOtherTxt
                        self.lifeInsuranceInfo = LifeInsurance(accidentalDeath: newQuestion[questionIndex][0].answer,
                                                 coverWithAnotherCompany: newQuestion[questionIndex][1].answer,
                                                 coveredDeclined: newQuestion[questionIndex][2].answer,
                                                               answer: self.LifeInsuranceTxt)
                        reload()
                    }
                }
                else if questionIndex == 4 {
                    if checkTxtValidation() {
                        self.DoYouSmokeTxt = self.questionOtherTxt
                        self.doYouSmokeInfo = DoYouSmoke(answer: newQuestion[questionIndex][0].answer, explaination: self.DoYouSmokeTxt)
                        reload()
                    }
                }
                
                else if questionIndex == 5 {
                    if checkTxtValidation() {
                        self.DrinkAlcoholTxt = self.questionOtherTxt
                        self.drinkAlcoholInfo = DrinkAlcohol(answer: newQuestion[questionIndex][0].answer, explaination: self.DrinkAlcoholTxt)
                        reload()
                    }
                }
                
                else if questionIndex == 6 {
                    if checkTxtValidation() {
                        self.DrugsOtherThanDrTxt = self.questionOtherTxt
                        self.drugsOtherThanDrInfo = DrugsOtherThanDr(answer: newQuestion[questionIndex][0].answer, explaination: self.DrugsOtherThanDrTxt)
                        reload()
                    }
                }
                else if questionIndex == 7 {
                    if checkTxtValidation() {
                        self.HazardourPursuitsTxt = self.questionOtherTxt
                        self.hazardourPursuitsInfo = HazardourPursuits(answer: newQuestion[questionIndex][0].answer, explaination: self.HazardourPursuitsTxt)
                        reload()
                    }
                }
                else if questionIndex == 8 {
                    if checkTxtValidation() {
                        self.ForiegnTravelTxt = self.questionOtherTxt
                        self.foriegnTravelInfo = ForiegnTravel(answer: newQuestion[questionIndex][0].answer, explaination: self.ForiegnTravelTxt)
                        reload()
                    }
                }
                else if questionIndex == 9 {
                    if checkTxtValidation() {
                        self.anyoneIfYesCovidTxt = self.questionOtherTxt
                        self.fever = newQuestion[questionIndex][0].answer
                        self.soreThroat = newQuestion[questionIndex][1].answer
                        self.dryCough = newQuestion[questionIndex][2].answer
                        self.bodyAche = newQuestion[questionIndex][3].answer
                        self.headAche = newQuestion[questionIndex][4].answer
                        self.shortnessOfBreath = newQuestion[questionIndex][5].answer
                        self.fatigue = newQuestion[questionIndex][6].answer
                        self.lossOfTaste = newQuestion[questionIndex][7].answer
                        self.lossOfSmell = newQuestion[questionIndex][8].answer
                        reload()
                    }
                }
                
                else if questionIndex == 10 {
                    if checkCovidTxtValidation() {
                        self.covid19Tested = newQuestion[questionIndex][0].answer
                        reload()
                    }
                }
                else if questionIndex == 11 {
                    self.inCasePositiveResultCompleteRecovery = newQuestion[questionIndex][0].answer
                    reload()
                }
                else if questionIndex == 12 {
                    self.past14ContactedWithAnyOne = newQuestion[questionIndex][0].answer
                    reload()
                }
                else if questionIndex == 13 {
                    self.noticeIssueForSelfQuarantine = newQuestion[questionIndex][0].answer
                    reload()
                }
                else if questionIndex == 14 {
                    if checkTxtValidation() {
                        self.stayOutSideCountryIfYesDetailsTxt = self.questionOtherTxt
                        self.stayOutsideCountryOrReturned = newQuestion[questionIndex][0].answer
                        reload()
                    }
                }
                else if questionIndex == 15 {
                    if checkTxtValidation() {
                        self.nextThreeMonthIfYesDetailsTxt = self.questionOtherTxt
                        nextThreeMonthsTravel = newQuestion[questionIndex][0].answer
                        self.takaFulQuestionInfo = TakafulQues(everDiagnosedWith: self.everDiagnosedInfo,
                                                          takingMedication: self.takingMedicationInfo,
                                                          diedOrSufferedBefore60: self.diedOrSufferedBeforeInfo,
                                                          lifeInsurance: self.lifeInsuranceInfo,
                                                          doYouSmoke: self.doYouSmokeInfo,
                                                          drinkAlcohol: self.drinkAlcoholInfo,
                                                          drugsOtherThanDr: self.drugsOtherThanDrInfo,
                                                          hazardourPursuits: self.hazardourPursuitsInfo,
                                                          foriegnTravel: self.foriegnTravelInfo
                        )
                        let covidInfo = Covid19Ques(fever: self.fever,
                                                    soreThroat: self.soreThroat,
                                                    dryCough: self.dryCough,
                                                    bodyAche: self.bodyAche,
                                                    headAche: self.headAche,
                                                    shortnessOfBreath: self.shortnessOfBreath,
                                                    fatigue: self.fatigue,
                                                    lossOfTaste: self.lossOfTaste,
                                                    lossOfSmell: self.lossOfSmell,
                                                    anyoneIfYesFurtherDetails: self.anyoneIfYesCovidTxt,
                                                    covid19Tested: self.covid19Tested,
                                                    dateOfTest: self.dateOfTestTxt ,
                                                    resultOfTest: self.resultOfTestTxt,
                                                    inCasePositiveResultCompleteRecovery: self.inCasePositiveResultCompleteRecovery,
                                                    past14ContactedWithAnyOne: self.past14ContactedWithAnyOne,
                                                    noticeIssueForSelfQuarantine: self.noticeIssueForSelfQuarantine,
                                                    stayOutsideCountryOrReturned: self.stayOutsideCountryOrReturned,
                                                    stayOutSideCountryIfYesDetails: self.stayOutSideCountryIfYesDetailsTxt,
                                                    nextThreeMonthsTravel: self.nextThreeMonthsTravel,
                                                    nextThreeMonthIfYesDetails: self.nextThreeMonthIfYesDetailsTxt
                        )
                        
                        let accountType = UserDefaults.standard.string(forKey: "accountType") ?? "BOTH"
                        let cnic = UserDefaults.standard.string(forKey: "CNIC") ?? ""
                        
                        let info = HealthDec(pension: self.pension, takafulQues: self.takaFulQuestionInfo, covid19Ques: covidInfo, cnic: cnic, accountType: accountType)
                        Constant.health_dec = info
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is PersonalInfoVC {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            if questionIndex > 0 {
                questionIndex = questionIndex - 1
                self.QuestionNoCollectionView.reloadData()
                self.collectionView.reloadData()
            }
        }
        if questionIndex == 0 {
            questionLbl.text = quesitons?.question1
        }
        else if questionIndex ==  9 {
            questionLbl.text = covidQuesitons?.question
        } else {
            questionLbl.text = "Please select the following Options."
        }
        
        if questionIndex > 8 {
            headerView.subLblTitle.text = "COVID-19 Questionnaire"
        } else {
            headerView.subLblTitle.text = "Questionnaire"
        }
        questionNo.text = "Q\(questionIndex + 1)"
    }
}

//MARK: - Collection Delegete
extension HealthQuestionaireVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if questionaireType == "health" {
            return newQuestion.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == QuestionNoCollectionView {
            let cell = collectionView.dequeueReusableCell(with: QuestionNoViewCell.self, for: indexPath)
            cell.containerView.backgroundColor =  UIColor.clear //UIColor.init(rgb: 0x47AE0A)
            cell.questionNoLbl.text = ""
            if indexPath.item == questionIndex  {
                cell.containerView.backgroundColor =   UIColor.init(rgb: 0x47AE0A)
                cell.questionNoLbl.text = "\(questionIndex + 1)/\(newQuestion.count)"
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(with: QuestionViewCell.self, for: indexPath)
            cell.question = newQuestion[questionIndex]
            cell.quesitonDelegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == QuestionNoCollectionView {
            return CGSize(width: collectionView.frame.width / CGFloat(self.newQuestion.count), height: collectionView.frame.height)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

protocol HealthQuestionaireUpdate: AnyObject {
    func updateQuestionaire(question: [OptionModel]?, index: Int)
    func checkTextFieldTxt(txt: String)
    
}

extension HealthQuestionaireVC: HealthQuestionaireUpdate {
    func updateQuestionaire(question: [OptionModel]?, index: Int) {
        if let question = question {
            let answer = question[index].answer
            if let row = newQuestion[questionIndex].firstIndex(where: {$0.name == question[index].name} ) {
                newQuestion[questionIndex][row].answer = answer
            }
        }
    }
    
    func checkTextFieldTxt(txt: String) {
        self.questionOtherTxt = txt
    }
    
}

extension HealthQuestionaireVC: BasicInfoViewProtoocl {
    
    func SaveDatasuccessfully(response: [SubmissionResponse]) {
        if response[0].errID == "00" {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: false)
//                if let data = self.info {
//                    self.router?.routerToKYCInfoVC(info: data)
//                }
            }
        }
    }
}
extension UICollectionView {
    func scrollToLast() {
        guard numberOfSections > 0 else {
            return
        }
        let lastSection = numberOfSections - 1

        guard numberOfItems(inSection: lastSection) > 0 else {
            return
        }

        let lastItemIndexPath = IndexPath(item: numberOfItems(inSection: lastSection) - 1,
                                          section: lastSection)
        scrollToItem(at: lastItemIndexPath, at: .bottom, animated: true)
    }
}
