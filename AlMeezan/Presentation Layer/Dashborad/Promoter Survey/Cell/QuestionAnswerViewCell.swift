//
//  QuestionAnswerViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 17/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class QuestionAnswerViewCell: UICollectionViewCell {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        //view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    private (set) lazy var radioBtn1: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 1
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 0.5
        btn.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        return btn
    }()
    private (set) lazy var radioBtn2: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 2
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        return btn
    }()

    private (set) lazy var radioBtn3: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 3
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        btn.backgroundColor = .clear
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        return btn
    }()
    private (set) lazy var questionView: UIView = { [unowned self] in
        var view = UIView()
        view.addSubview(questionLbl)
        view.layer.borderColor = UIColor.init(rgb: 0xE6E6E6).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private (set) lazy var questionLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.text = "High blood pressure"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 0
        return label
    }()
    private (set) lazy var radioStackView: UIStackView = { [unowned self] in
        var view = UIStackView()
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()
    private (set) lazy var stackView: UIStackView = { [unowned self] in
        var view = UIStackView(arrangedSubviews: [questionView, radioStackView])
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 0
        return view
    }()
    weak var delegate: UpdateQuestionAnswer?
    var indexRow: Int!
    var question: Questions? {
        didSet {
            guard let data = question else { return }
            questionLbl.text = data.question
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUIView()
        radioBtn1.isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func loadUIView() {
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if !stackView.isDescendant(of: containerView) {
            containerView.addSubview(stackView)
        }
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(55)
        }
        if !questionLbl.isDescendant(of: questionView) {
            questionView.addSubview(questionLbl)
        }
        questionLbl.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-4)
        }
        
        
        radioStackView.addArrangedSubview(radioBtn1)
        radioStackView.addArrangedSubview(radioBtn2)
        radioStackView.addArrangedSubview(radioBtn3)
    }
    
    @objc private func didTapOnOptionBtn(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 1:
            delegate?.updateAnswer("Satisfactory", id: indexRow)
            radioBtn1.isSelected = true
            radioBtn2.isSelected = false
            radioBtn3.isSelected = false
        case 2:
            delegate?.updateAnswer("Un Satisfactory", id: indexRow)
            radioBtn1.isSelected = false
            radioBtn2.isSelected = true
            radioBtn3.isSelected = false
        case 3:
            delegate?.updateAnswer("Not Applicable", id: indexRow)
            radioBtn1.isSelected = false
            radioBtn2.isSelected = false
            radioBtn3.isSelected = true
        default:
            break
        }
    }
    
}
