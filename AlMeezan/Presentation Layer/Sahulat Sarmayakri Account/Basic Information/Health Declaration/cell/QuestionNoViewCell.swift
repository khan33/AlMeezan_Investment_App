//
//  QuestionNoViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 08/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class QuestionNoViewCell: UICollectionViewCell {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        //view.backgroundColor =  UIColor.init(rgb: 0x47AE0A)
        view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    
    private (set) lazy var questionNoLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "1/9."
        label.textColor =  UIColor.init(rgb:0x47AE0A)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 10)
        label.numberOfLines = 0
        return label
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
    private func loadUIView()  {
        
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        if !questionNoLbl.isDescendant(of: contentView) {
            contentView.addSubview(questionNoLbl)
        }
        
        questionNoLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4).isActive = true
        questionNoLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        questionNoLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
    }
    
}
