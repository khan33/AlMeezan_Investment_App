//
//  QuestionViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 06/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

enum QuestionComponentEnum {
    case question
    case other
    var name: String {
        switch self {
        case .question:
            return "question"
        case .other:
            return "other"
        }
    }
}

class QuestionViewCell: UICollectionViewCell {
    private var flowLayout: UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.estimatedItemSize = CGSize.zero
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        return flow
    }()
    private (set) lazy var collectionViewItems:UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator  = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(QuestionItemCell.self, forCellWithReuseIdentifier: "QuestionItemCell")
        collectionView.register(OtherViewCell.self, forCellWithReuseIdentifier: "OtherViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView;
    }()
    weak var quesitonDelegate: HealthQuestionaireUpdate?
    var totalQuestion = 0
    private var questionComponents : [QuestionComponentEnum] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionViewItems.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadUIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadUIView()  {
        if !collectionViewItems.isDescendant(of: contentView) {
            contentView.addSubview(collectionViewItems)
        }
        collectionViewItems.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collectionViewItems.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collectionViewItems.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collectionViewItems.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    var question: [OptionModel]? {
        didSet {
            let isAnswer = question?.filter( { $0.answer == 1 } )
            if isAnswer?.count ?? 0 > 0 {
                let isRequired = question?.filter({ $0.textFieldRequired == true})
                if isRequired?.count ?? 0 > 0 {
                    totalQuestion = question?.count ?? 0
                } else {
                    totalQuestion = (question?.count ?? 0) - 1
                }
            } else {
                totalQuestion = (question?.count ?? 0) - 1
            }
            collectionViewItems.reloadData()
        }
    }
}
//MARK: - Collection Delegete

extension QuestionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalQuestion
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: QuestionItemCell.self, for: indexPath)
        cell.questionLbl.text = question?[indexPath.row].name
        cell.questionNo.text = ""
        cell.questionNo.isHidden = true
        cell.indexRow = indexPath.row
        cell.quesiton_model = question?[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height = 160.0
        if question?[indexPath.row].code == "other" {
            height = 200.0
        }
        return CGSize(width:  collectionView.frame.width, height: height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    
    
}
extension QuestionViewCell: QuestionAnswerProtocol {
    func getAnswer(row: Int, option: AnswerOption, answer: Bool) {
        if option == AnswerOption.yes {
            question?[row].answer = 1
            collectionViewItems.scrollToBottom()
            quesitonDelegate?.updateQuestionaire(question: question, index: row)
        } else {
            question?[row].answer = 0
            quesitonDelegate?.updateQuestionaire(question: question, index: row)
        }
    }
    
    func getTxtFieldTxt(txt: String) {
        quesitonDelegate?.checkTextFieldTxt(txt: txt)
    }
}
