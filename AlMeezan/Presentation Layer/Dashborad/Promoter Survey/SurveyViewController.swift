//
//  SurveyViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 10/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {
    private (set) lazy var containerView: UIView = { [unowned self] in
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .black
        view.alpha = 0.888888
        return view
    }()
    
    private (set) lazy var questionTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = "NET PROMOTER SURVEY"
        label.textColor =  UIColor.init(rgb:0x5B5F78)
        label.font = UIFont(name: AppFontName.robotoMedium, size: 18)
        label.numberOfLines = 0
        return label
    }()
    
    
    private (set) lazy var closeBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "closegray"), for: .normal)
        btn.addTarget(self, action: #selector(didTapCloseBtn), for: .touchUpInside)
        return btn
    }()
    private (set) lazy var collectionView:UICollectionView = { [unowned self] in
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        let width = UIScreen.main.bounds.size.width - 32
        flow.estimatedItemSize = CGSize(width: width, height: 10)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        collectionView.register(SurveyQuestionCell.self, forCellWithReuseIdentifier: "SurveyQuestionCell")
        collectionView.register(SurveyScoreViewCell.self, forCellWithReuseIdentifier: "SurveyScoreViewCell")
        collectionView.register(ScroeAnswerViewCell.self, forCellWithReuseIdentifier: "ScroeAnswerViewCell")
        collectionView.register(SurveyFeedbackCell.self, forCellWithReuseIdentifier: "SurveyFeedbackCell")
        collectionView.clipsToBounds = true
        return collectionView;
    }()
    var question_data: [Questions]?
    
    var howLikely: String = "Neutral"
    var productOffering: String = "Satisfactory"
    var returns: String = "Satisfactory"
    var services: String = "Satisfactory"
    var vAS: String = "Satisfactory"
    var management: String = "Satisfactory"
    var shariahCompliantValue: String = "Satisfactory"
    var otherFeedback: String = ""
    
    
    var router: SurveyViewRouterProtocol?
    var interactor: SurveyViewInteractorProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        question_data = loadJson(filename: "SurveyQuestion")
        collectionView.reloadData()
    }
    
    @objc private func didTapCloseBtn() {
        showLoader()
        let request = SurveyCancelModel()
        interactor?.cancelSurvey(request)
        dismiss(animated: true, completion: nil)
        
    }
    func loadJson(filename fileName: String) -> [Questions]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.questions
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        if !containerView.isDescendant(of: self.view) {
            self.view.addSubview(containerView)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(self.view).multipliedBy(0.75)
//            make.width.equalTo(self.view).multipliedBy(0.9)
        }
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 8
        
        if !questionTitle.isDescendant(of: self.containerView) {
            containerView.addSubview(questionTitle)
        }
        questionTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
        }
        
        if !closeBtn.isDescendant(of: self.containerView) {
            containerView.addSubview(closeBtn)
        }
        
        closeBtn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
        }
        
        if !collectionView.isDescendant(of: self.containerView) {
            self.containerView.addSubview(collectionView)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(closeBtn.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
            //make.bottom.equalToSuperview().inset(16)
        }
        collectionView.reloadData()
    }
    @objc private
    func didTapOnSubmitBtn(_ sender: UIButton) {
        if howLikely == "Un Satisfactory" && otherFeedback == "" {
            self.showAlert(title: "Alert", message: "Please provide your feedback/suggestion.", controller: self) {
                
            }
            return
        }
        
        showLoader()
        let request = SurveyRequestModel(howLikely: howLikely, productOffering: productOffering, returns: returns, services: services, vas: vAS, management: management, shariahCompliantValues: shariahCompliantValue, otherFeedback: otherFeedback)
        interactor?.surveySubmission(request)
    }
    
}
extension SurveyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(with: SurveyQuestionCell.self, for: indexPath)
            cell.question = question_data?[indexPath.row]
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(with: SurveyScoreViewCell.self, for: indexPath)
            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(with: ScroeAnswerViewCell.self, for: indexPath)
            cell.question = question_data?[1].sub_questions
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(with: SurveyFeedbackCell.self, for: indexPath)
            cell.delegate = self
            cell.centerBtn.addTarget(self, action: #selector(didTapOnSubmitBtn), for: .touchUpInside)
            return cell
        }
    }
    
}


extension SurveyViewController: UpdateQuestionAnswer {
    func updateAnswer(_ answer: String, id: Int) {
        switch id {
        case 1:
            if answer == "Very Likely" {
                howLikely = "Satisfactory"
                
            } else if answer == "Not Likely" {
                howLikely = "Un Satisfactory"
            } else  {
                howLikely = "Neutral"
            }
        case 2:
            productOffering = answer
        case 3:
            returns = answer
        case 4:
            services = answer
        case 5:
            vAS  = answer
        case 6:
            management = answer
        case 7:
            shariahCompliantValue = answer
        default:
            otherFeedback = answer
        }
    }
}
extension SurveyViewController: SurveyViewControllerProtocol {
    func response(with response: SurveyResponseModel) {
        DispatchQueue.main.async {
            if response.errId == "00" {
                self.hideLoader()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

protocol UpdateQuestionAnswer: AnyObject {
    func updateAnswer(_ answer: String, id: Int)
}

protocol SurveyViewControllerProtocol: AnyObject {
    func response(with response: SurveyResponseModel)
}
