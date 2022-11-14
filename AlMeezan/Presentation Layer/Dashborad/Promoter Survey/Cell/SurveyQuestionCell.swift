//
//  SurveyQuestionCell.swift
//  AlMeezan
//
//  Created by Atta khan on 10/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class SurveyQuestionCell: UICollectionViewCell {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor =  UIColor.white
        return view
    }()
    private (set) lazy var questionNo: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Q 1"
        label.textColor =  UIColor.init(rgb:0xB9BBC6)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    private (set) lazy var questionLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = ""
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    private var flowLayout: UICollectionViewFlowLayout = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .vertical
        flow.estimatedItemSize = CGSize.zero
        flow.minimumInteritemSpacing = 0
        flow.minimumLineSpacing = 0
        return flow
    }()
    
    private (set) lazy var collectionView:UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SurveyAnswerCell.self, forCellWithReuseIdentifier: "SurveyAnswerCell")
        return collectionView;
    }()
    
    
    
    private (set) lazy var bottomView: UIView = {[unowned self] in
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    var radioOption:Int? = 0
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    weak var delegate: UpdateQuestionAnswer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    
    var question: Questions? {
        didSet {
            guard let data = question else { return }
            questionLbl.text = data.question
            collectionView.reloadData()
        }
    }
    
    private func loadUIView()  {
        
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        
        containerView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(8)
        }
        if !questionNo.isDescendant(of: containerView) {
            containerView.addSubview(questionNo)
        }

        questionNo.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
        }

        if !questionLbl.isDescendant(of: containerView) {
            containerView.addSubview(questionLbl)
        }
        questionLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(questionNo.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        if !collectionView.isDescendant(of: containerView) {
            containerView.addSubview(collectionView)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(questionLbl.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(110)
        }
        if !bottomView.isDescendant(of: containerView) {
            containerView.addSubview(bottomView)
        }
        bottomView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerX.equalTo(containerView)
            make.height.equalTo(0.5)
            make.top.equalTo(collectionView.snp.bottom).offset(2)
            make.bottom.equalToSuperview().inset(2)
        }
        bottomView.backgroundColor = UIColor.init(rgb: 0xE6E6E6)
    }
}
extension SurveyQuestionCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SurveyAnswerCell.self, for: indexPath)
        cell.yesLbl.text = question?.options[indexPath.row].answer
        if indexPath.row == radioOption {
            cell.yesRadioBtn.isSelected = true
        } else {
            cell.yesRadioBtn.isSelected = false
        }
        cell.yesRadioBtn.tag = indexPath.row
//        cell.yesRadioBtn.addTarget(self, action: #selector(didTapOnRadioBtn), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        radioOption = indexPath.row
        if let option = question?.options[indexPath.row].answer,
           let id = question?.id {
                delegate?.updateAnswer(option, id: id)
        }
        collectionView.reloadData()
    }
    
    @objc func didTapOnRadioBtn(_ sender: UIButton) {
        let tag  = sender.tag
        if let option = question?.options[tag].answer,
           let id = question?.id {
                delegate?.updateAnswer(option, id: id)
        }
        collectionView.reloadData()
    }
}
