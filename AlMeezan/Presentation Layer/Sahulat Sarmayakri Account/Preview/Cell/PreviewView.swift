//
//  PreviewView.swift
//  AlMeezan
//
//  Created by Atta khan on 28/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class PreviewTitleView: UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor.rgb(red: 138, green: 38, blue: 155, alpha: 1)
        label.font = UIFont(name: AppFontName.circularStdBold, size: 14)
        label.text = "Customer Details"
        return label
    }()
    
    private (set) lazy var borderView: UIView = { [unowned self] in
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.1)
        return view
    }()
    
    init(heading: String) {
        super.init(frame: CGRect.zero)
        lblTitle.text = heading
        setUpContainerView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpContainerView() {
        if !containerView.isDescendant(of: self) {
            self.addSubview(containerView)
        }
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 36).isActive = true
    
        
        
        if !borderView.isDescendant(of: containerView) {
            containerView.addSubview(borderView)
        }

        borderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        borderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        if !lblTitle.isDescendant(of: containerView) {
            containerView.addSubview(lblTitle)
        }
        
        lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2).isActive = true
        lblTitle.bottomAnchor.constraint(equalTo: borderView.topAnchor, constant: 1).isActive = true
        
    }
    
}



class PreviewView: UIView {
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        return view
    }()
    
    private (set) lazy var lblHeading: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 1)
        lbl.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    private (set) lazy var lblValue: UILabel = {[unowned self] in
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        lbl.textColor = UIColor.rgb(red: 138, green: 38, blue: 155, alpha: 1)
        lbl.font = UIFont(name: AppFontName.robotoRegular, size: 12)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    
    private (set) lazy var borderView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.1)
        return view
    }()
    var height: CGFloat = 20.0
    init(heading: String, value: String, isBorderView: Bool) {
        super.init(frame: CGRect.zero)
        lblHeading.text = heading
        lblValue.text = value
        borderView.isHidden = isBorderView
        
        if heading == "Questionnaire" {
            lblValue.font = UIFont(name: AppFontName.robotoMedium, size: 16)
        }
        
        setUpContainerView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpContainerView() {
        if !containerView.isDescendant(of: self) {
            self.addSubview(containerView)
        }
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        if !borderView.isDescendant(of: containerView) {
            containerView.addSubview(borderView)
        }

        borderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        borderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        if !lblHeading.isDescendant(of: containerView) {
            containerView.addSubview(lblHeading)
        }
        
        lblHeading.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        lblHeading.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.45).isActive = true
        lblHeading.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2).isActive = true
        lblHeading.bottomAnchor.constraint(equalTo: borderView.topAnchor, constant: -4).isActive = true
        
        if !lblValue.isDescendant(of: containerView) {
            containerView.addSubview(lblValue)
        }
        
        lblValue.leadingAnchor.constraint(equalTo: lblHeading.trailingAnchor, constant: 8).isActive = true
        lblValue.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        lblValue.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2).isActive = true
        lblValue.bottomAnchor.constraint(equalTo: borderView.topAnchor, constant: -4).isActive = true
        
        
        
        
    }
}
extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
