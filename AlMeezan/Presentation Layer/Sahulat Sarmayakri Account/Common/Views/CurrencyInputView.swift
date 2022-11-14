//
//  CurrencyInputView.swift
//  AlMeezan
//
//  Created by Atta khan on 24/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import Foundation
import UIKit
class CurrencyInputView: UIView {
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
//        view.autocapitalizationType = .none
        //view.setLeftPaddingPoints(5)
        view.textAlignment = .left
        view.textColor = .black
        view.font = AppFonts.txtFieldFont
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        return view
    }()
    private (set) lazy var borderView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        return view
    }()
    var initialFieldString = ""
    private var enterTextCloser: ((_ text: String) -> Void)!
    var heading: String = ""
    init(heading: String, placeholder: String, isPasswordEnable: Bool, enterTextCloser: @escaping (_ text: String) -> Void) {
        super.init(frame: CGRect.zero)
        self.enterTextCloser = enterTextCloser
        if isPasswordEnable {
            txtField.isSecureTextEntry = true
        } else {
            txtField.isSecureTextEntry = false
        }
        setUpContainerView()
        lblHeading.text = heading
        txtField.placeholder = placeholder
        self.heading = heading
        txtField.delegate = self
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
//        containerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        
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
        if !borderView.isDescendant(of: containerView) {
            containerView.addSubview(borderView)
        }
        borderView.topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 2).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderView.leadingAnchor.constraint(equalTo: txtField.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: txtField.trailingAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2).isActive = true
        
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {

        formatCurrency(string: textField.text ?? "")
        //enterTextCloser(textField.text ?? "")
    }
    
    func setData(text: String?) {
        txtField.text = text
    }
    
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //let numberFromField = NSString(string: string).intValue
        let str = string.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal)
        let numberFromField = Int(str)
        if let number = numberFromField {
            txtField.text = formatter.string(from: NSNumber(value: number))
        } else {
            txtField.text = ""
        }
        enterTextCloser(txtField.text ?? "")
    }
}
extension CurrencyInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " { // prevent space on first character
            return false
        }
        if textField.text?.last == " " && string == " " { // allowed only single space
            return false
        }
        if string == " " { return true } // now allowing space between name
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
            // Check for invalid input characters
        
        if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
            if heading == AppString.Heading.numbeerOfTransaction {
                return newLength <= 6
            } else {
                if let chanel = UserDefaults.standard.string(forKey: "OnlineAccountType") {
                    if chanel == "SSA" {
                        return newLength <= 9
                    }
            }
            return true
        }
            
        }
        return true
    }
}
