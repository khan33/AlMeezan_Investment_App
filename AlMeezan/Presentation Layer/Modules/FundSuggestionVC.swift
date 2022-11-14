//
//  FundSuggestionVC.swift
//  AlMeezan
//
//  Created by Atta khan on 15/10/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class FundSuggestionVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var countNotificationLbl: UIButton!

    var question_data: [Questions]?
    var questionIndex = 0
    var totalQuestion = 0
    var questionWeight =  [Int: Int]()
    var selectedAnswer = [String : Int]()
    var isSelected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.delegate = self
        tableView.dataSource = self
        question_data = loadJson(filename: "questions")
        totalQuestion = question_data?.count ?? 0
        loadQuestion()
        nextBtn.backgroundColor = UIColor.themeColor
        nextBtn.setTitleColor(UIColor.white, for: .normal)
        collectionView.delegate = self
        collectionView.dataSource = self
        prevBtn.isHidden = true
         countNotificationLbl.isHidden = true
        Utility.shared.renderNotificationCount(countNotificationLbl)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                loginBtn.setImage(UIImage(named: "logout-icon-1"), for: .normal)
            } else {
                loginBtn.setImage(UIImage(named: "logout-icon"), for: .normal)
            }
        }
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
    func loadQuestion() {
        if totalQuestion == questionIndex + 1 {
            nextBtn.setTitle("SUBMIT", for: .normal)
        } else {
            nextBtn.setTitle("NEXT", for: .normal)
        }
        questionTitle.text = question_data?[questionIndex].question
        collectionView.reloadData()
    }
    @IBAction func tapOnPrevBtn(_ sender: UIButton) {
        if questionIndex > 0 {
            questionIndex -= 1
            loadQuestion()
            tableView.reloadData()
        }
        if questionIndex == 0 {
            prevBtn.isHidden = true
        } else {
            prevBtn.isHidden = false
        }
    }
    @IBAction func tapOnNextBtn(_ sender: UIButton) {
        isSelected = (question_data?[questionIndex].isSelected)!
        if isSelected {
            prevBtn.isHidden = false
            if totalQuestion > questionIndex + 1 {
                questionIndex += 1
                loadQuestion()
                tableView.reloadData()
            } else {
                let total = questionWeight.compactMap { $0.value }.reduce(0, +)
                let vc = FundFilterVC.instantiateFromAppStroyboard(appStoryboard: .main)
                vc.fund_value = total
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            self.showAlert(title: "Alert", message: "Please select one option.", controller: self) {
            }
        }
    }
    @IBAction func navigateToBackController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapOnNotificationBtn(_ sender: Any) {
        let vc = NotificationsVC.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tapOnLoginBtn(_ sender: Any) {
        loginOption()
     }
}
extension FundSuggestionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question_data?[questionIndex].options.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerViewCell", for: indexPath) as! AnswerViewCell
        cell.answerTitleLbl.text = question_data?[questionIndex].options[indexPath.row].answer
        cell.tickImg.isHidden = true
        print(isSelected)
        cell.tintColor = UIColor.green
        if selectedAnswer.count > 0 {
            let selectedIndex = selectedAnswer[question_data?[questionIndex].question ?? ""]
            if selectedIndex == indexPath.row {
                cell.tickImg.isHidden = false
                //isSelected = true
                question_data?[questionIndex].isSelected = true
                cell.borderLine.backgroundColor = UIColor.themeColor
                cell.answerTitleLbl.textColor = UIColor.black
            } else {
                cell.tickImg.isHidden = true
                cell.borderLine.backgroundColor = UIColor.lightGray
                cell.answerTitleLbl.textColor = UIColor.menuLblColor
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell =  tableView.cellForRow(at: indexPath) as! AnswerViewCell
        questionWeight[questionIndex] = question_data?[questionIndex].weight?[indexPath.row].value
        if let question = question_data?[questionIndex].question {
            selectedAnswer[question] = indexPath.row
        }
        for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) as? AnswerViewCell {
                cell.tickImg.isHidden = row == indexPath.row ? false : true
                cell.borderLine.backgroundColor = UIColor.lightGray
            }
        }
        question_data?[questionIndex].isSelected = true
        cell.borderLine.backgroundColor = UIColor.themeColor
        cell.answerTitleLbl.textColor = UIColor.black
        cell.tickImg.isHidden = false
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        question_data?[questionIndex].isSelected = false
        let cell =  tableView.cellForRow(at: indexPath) as! AnswerViewCell
        cell.borderLine.backgroundColor = UIColor.lightGray
        cell.tickImg.isHidden = true
        cell.answerTitleLbl.textColor = UIColor.menuLblColor
        questionWeight.removeValue(forKey: questionIndex)
    }
}
extension FundSuggestionVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalQuestion
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scoreViewCell", for: indexPath) as! ScoreViewCell
        cell.topLine.backgroundColor = UIColor.clear
        cell.currentQuestionLbl.text = ""
        if indexPath.item == questionIndex {
            cell.topLine.backgroundColor = UIColor.themeColor
            cell.currentQuestionLbl.text = "\(questionIndex + 1) / \(totalQuestion)"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (SCREEN_WIDTH / CGFloat(totalQuestion)) - 10 , height: collectionView.frame.height)
    }
}
