//
//  SurveyFeedbackCell.swift
//  AlMeezan
//
//  Created by Atta khan on 11/05/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class SurveyFeedbackCell: UICollectionViewCell {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        //view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    private (set) lazy var headingLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Feedback/Suggestion (Max limit 2000 characters)"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    private (set) lazy var characterLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2000 charachters remaining"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 11)
        label.numberOfLines = 1
        return label
    }()
    
    private (set) lazy var textArea: UITextView = { [unowned self] in
        let view = UITextView()
        view.backgroundColor = UIColor.init(rgb:0xededeb)
        view.layer.cornerRadius = 8
        view.textColor = .black
        view.textAlignment = .left
        view.isEditable = true
        view.layer.masksToBounds = true
        view.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private (set) lazy var centerBtn: UIButton = {[unowned self] in
        let view = UIButton()
        view.clipsToBounds = true
        view.backgroundColor = .themeColor
        view.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        view.setTitleColor(.white, for: UIControl.State.init())
        view.cornerReduis(reduis: 20, BGColor: .themeColor, borderColor: .clear, borderWidth: 0)
        view.setTitle("SUBMIT", for: .normal)
        return view
    }()
    weak var delegate: UpdateQuestionAnswer?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let txt = "Feedback/Suggestion (Max limit 2000 characters)"
        let attributedStr = NSMutableAttributedString(string: txt)
        
        let range = attributedStr.mutableString.range(of: "(Max limit 2000 characters)", options: .caseInsensitive)
        attributedStr.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 11), range: range)
        attributedStr.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x4F5A65), range: range)
        headingLbl.attributedText = attributedStr
        
        loadUIView()
        textArea.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var width: NSLayoutConstraint = {
        let width = contentView.widthAnchor.constraint(equalToConstant: bounds.size.width)
        width.isActive = true
        return width
    }()
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        width.constant = bounds.size.width
        return contentView.systemLayoutSizeFitting(CGSize(width: targetSize.width, height: 1))
    }
    func loadUIView() {
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        if !headingLbl.isDescendant(of: containerView) {
            containerView.addSubview(headingLbl)
        }
        
        headingLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        headingLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        
        
        if !textArea.isDescendant(of: containerView) {
            containerView.addSubview(textArea)
        }
        textArea.topAnchor.constraint(equalTo: headingLbl.bottomAnchor, constant: 8).isActive = true
        textArea.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        textArea.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        textArea.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        if !characterLbl.isDescendant(of: containerView) {
            containerView.addSubview(characterLbl)
        }
        characterLbl.topAnchor.constraint(equalTo: textArea.bottomAnchor, constant: 8).isActive = true
        characterLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        
        
        if !centerBtn.isDescendant(of: containerView) {
            containerView.addSubview(centerBtn)
        }
        centerBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(characterLbl.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
    }
}


extension SurveyFeedbackCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count + text.count - range.length
        characterLbl.text = "\(newLength) / 2000"
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let txt = textView.text {
            delegate?.updateAnswer(txt, id: 900)
        }
    }
}
