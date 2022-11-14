//
//  SurveyScoreViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 16/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class SurveyScoreViewCell: UICollectionViewCell {
    
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = .white
        //view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    private (set) lazy var questionNo: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = "Q 2"
        label.textColor =  UIColor.init(rgb:0xB9BBC6)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    private (set) lazy var questionLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = "Why did you give this score?"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private (set) lazy var satisfactoryLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = "1 - Satisfactory"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private (set) lazy var unSatisfactoryLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = "2 - Un Satisfactory"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    private (set) lazy var nonApplicableLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = "3 - Not Applicable"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private (set) lazy var stackView: UIStackView = { [unowned self] in
        var view = UIStackView(arrangedSubviews: [satisfactoryLbl, unSatisfactoryLbl, nonApplicableLbl])
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()
    
    private (set) lazy var numberOneBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("1", for: .normal)
        btn.setTitleColor(UIColor.init(rgb:0x232746), for: .normal)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        return btn
    }()
    private (set) lazy var numberTwoBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("2", for: .normal)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        btn.setTitleColor(UIColor.init(rgb:0x232746), for: .normal)
        return btn
    }()
    
    private (set) lazy var numberThreeBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.setTitle("3", for: .normal)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        btn.setTitleColor(UIColor.init(rgb:0x232746), for: .normal)
        return btn
    }()
    
    
    
    
    private (set) lazy var numberStackView: UIStackView = { [unowned self] in
        var view = UIStackView(arrangedSubviews: [numberOneBtn, numberTwoBtn, numberThreeBtn])
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()
    private (set) lazy var questionView: UIView = { [unowned self] in
        var view = UIView()
        view.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        view.layer.borderWidth = 0.5
        return view
    }()
    private (set) lazy var scoreStackView: UIStackView = { [unowned self] in
        var view = UIStackView(arrangedSubviews: [questionView, numberStackView])
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()
    
    private (set) lazy var bottomView: UIView = { [unowned self] in
        let view = UIView()
        return view
    }()
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUIView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    
    private func loadUIView() {
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.top.bottom.leading.trailing.equalToSuperview().inset(8)
        }
        
        
        if !questionNo.isDescendant(of: containerView) {
            containerView.addSubview(questionNo)
        }
        questionNo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        
        if !questionLbl.isDescendant(of: containerView) {
            containerView.addSubview(questionLbl)
        }
        questionLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalTo(questionNo.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        if !stackView.isDescendant(of: containerView) {
            containerView.addSubview(stackView)
        }
        stackView.backgroundColor = UIColor.rgb(red: 226, green: 226, blue: 226, alpha: 1)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(questionNo.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }

        if !bottomView.isDescendant(of: containerView) {
            containerView.addSubview(bottomView)
        }
        bottomView.backgroundColor = .lightGray
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        
        if !scoreStackView.isDescendant(of: containerView) {
            containerView.addSubview(scoreStackView)
        }
        scoreStackView.backgroundColor = .white //UIColor.rgb(red: 226, green: 226, blue: 226, alpha: 1)
        
        scoreStackView.snp.makeConstraints { make in
            make.top.equalTo(bottomView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        
        
    }
}
