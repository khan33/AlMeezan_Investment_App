//
//  DatePickerView.swift
//  AlMeezan
//
//  Created by Atta khan on 12/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit
class DatePickerView : UIView {
    
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
        lbl.textColor = UIColor.rgb(red: 35, green: 39, blue: 79, alpha: 1)
        lbl.font = AppFonts.txtFieldLblFont
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.clipsToBounds = true
        return lbl
    }()
    
    lazy var txtField: UITextField = {[unowned self] in
        let view = UITextField()
        view.autocapitalizationType = .none
        //view.setLeftPaddingPoints(5)
        view.textAlignment = .left
        view.textColor = .black
        view.font = AppFonts.txtFieldFont
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private (set) lazy var btnIcon: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "down_Arrow"), for: .normal)
        return btn
    }()
    
    private (set) lazy var btn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
        return btn
    }()
    
    
    private (set) lazy var borderView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    private var enterTextCloser: (() -> Void)!
    
    var dataSource: GenericPickerDataSource<Country1>?

    
    init(heading: String, placeholder: String, image: String , enterTextCloser: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        self.enterTextCloser = enterTextCloser
        setUpContainerView()
        lblHeading.text = heading
        txtField.placeholder = placeholder
        btnIcon.setImage(UIImage(named: image), for: .normal)
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
    
        
        if !lblHeading.isDescendant(of: containerView) {
            containerView.addSubview(lblHeading)
        }
        
        lblHeading.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        lblHeading.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        lblHeading.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        
        
        if !txtField.isDescendant(of: containerView) {
            containerView.addSubview(txtField)
        }
        
        txtField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        txtField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        txtField.topAnchor.constraint(equalTo: lblHeading.bottomAnchor, constant: 4).isActive = true
        txtField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        if !btnIcon.isDescendant(of: containerView) {
            containerView.addSubview(btnIcon)
        }
        btnIcon.trailingAnchor.constraint(equalTo: txtField.trailingAnchor, constant: -8).isActive = true
        btnIcon.centerYAnchor.constraint(equalTo: txtField.centerYAnchor, constant: 0).isActive = true

        if !borderView.isDescendant(of: containerView) {
            containerView.addSubview(borderView)
        }
        borderView.topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 2).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderView.leadingAnchor.constraint(equalTo: txtField.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: txtField.trailingAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2).isActive = true
        
        if !btn.isDescendant(of: containerView) {
            containerView.addSubview(btn)
        }
        
        btn.leadingAnchor.constraint(equalTo: txtField.leadingAnchor).isActive = true
        btn.topAnchor.constraint(equalTo: txtField.topAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: txtField.trailingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: txtField.bottomAnchor).isActive = true
        
    }
    
    @objc private
    func btnPressed() {
        self.enterTextCloser()
    }
    
    func setData(text: String?) {
        txtField.text = text
    }
}
