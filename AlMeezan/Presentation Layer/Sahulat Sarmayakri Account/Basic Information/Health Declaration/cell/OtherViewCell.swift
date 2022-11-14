//
//  OtherViewCell.swift
//  AlMeezan
//
//  Created by Atta khan on 25/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class OtherViewCell: UICollectionViewCell {
    
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor =  UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.05)
        view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    
    private (set) lazy var questionLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "High blood pressure, chest pain, stroke or any heart or circulatory trouble?"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    lazy var txtField: UITextField = {[unowned self] in
        let view = UITextField()
        view.textAlignment = .left
        view.textColor = .black
        view.font = AppFonts.txtFieldFont
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.placeholder = "Enter your explaination"
        //view.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        return view
    }()
    private (set) lazy var borderView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
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
    
    private func loadUIView()  {
        
        if !containerView.isDescendant(of: contentView) {
            contentView.addSubview(containerView)
        }
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        if !questionLbl.isDescendant(of: containerView) {
            containerView.addSubview(questionLbl)
        }

        questionLbl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        questionLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        questionLbl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        
        if !txtField.isDescendant(of: containerView) {
            containerView.addSubview(txtField)
        }
        
        txtField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        txtField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        txtField.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 4).isActive = true
        txtField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        if !borderView.isDescendant(of: containerView) {
            containerView.addSubview(borderView)
        }
        borderView.topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 2).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderView.leadingAnchor.constraint(equalTo: txtField.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: txtField.trailingAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2).isActive = true
        
        
    }
}
