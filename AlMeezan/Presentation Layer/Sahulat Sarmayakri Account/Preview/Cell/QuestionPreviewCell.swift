//
//  QuestionPreviewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 21/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class QuestionPreviewCell: UICollectionViewCell {
    
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor =  UIColor.white
        return view
    }()
    private (set) lazy var questionNo: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Q 1"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    
    private (set) lazy var questionLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "High blood pressure, chest pain, stroke or any heart or circulatory trouble?"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 0
        return label
    }()
   
    
    private (set) lazy var lblAnswer: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Yes"
        label.textColor =  UIColor.themeColor
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 1
        return label
    }()
    
    
    private (set) lazy var bottomView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
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
    
    var quesiton_model: OptionModel? {
        didSet {
            if let answer = quesiton_model?.answer {
                
            }
        }
    }
    
    
    private func loadUIView()  {
        
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        
        if !questionNo.isDescendant(of: containerView) {
            containerView.addSubview(questionNo)
        }
        questionNo.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        questionNo.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        
        
        if !questionLbl.isDescendant(of: containerView) {
            containerView.addSubview(questionLbl)
        }

        questionLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        questionLbl.leadingAnchor.constraint(equalTo: questionNo.trailingAnchor, constant: 10).isActive = true
        questionLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        
        if !lblAnswer.isDescendant(of: containerView) {
            containerView.addSubview(lblAnswer)
        }
        lblAnswer.leadingAnchor.constraint(equalTo: questionLbl.leadingAnchor).isActive = true
        lblAnswer.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 8).isActive = true
        
        if !bottomView.isDescendant(of: containerView) {
            containerView.addSubview(bottomView)
        }
        bottomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        bottomView.backgroundColor = .lightGray
        
        
    }
    
}
