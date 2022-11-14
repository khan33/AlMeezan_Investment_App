//
//  TextInputView.swift
//  AlMeezan
//
//  Created by Atta khan on 15/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import UIKit
class TextInputView : UIView {
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
        textField.text = textField.text?.uppercased()
        enterTextCloser(textField.text ?? "")
    }
    
    func setData(text: String?) {
        txtField.text = text
    }
    
    func formatCurrency(string: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        //let numberFromField = NSString(string: string).intValue
        let numberFromField = Int(string)
        if let number = numberFromField {
            txtField.text = formatter.string(from: NSNumber(value: number))
        } else {
            txtField.text = ""
        }
    }
}
extension TextInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location == 0 && string == " " { // prevent space on first character
            return false
        }
        if textField.text?.last == " " && string == " " { // allowed only single space
            return false
        }
        if string == " " { return true } // now allowing space between name
//        if string.rangeOfCharacter(from: CharacterSet.letters.inverted) != nil {
//            return false
//        }
        let currentCharacterCount = textField.text?.count ?? 0
        //let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        
        if textField.keyboardType == .asciiCapableNumberPad {
            // Check for invalid input characters
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
                
                if heading == AppString.Heading.cnic || heading == AppString.Heading.cnicNicop || heading == AppString.Heading.cnicPassport || heading == AppString.Heading.cnicMobileOwner {
                    return newLength <= 13
                } else if heading == AppString.Heading.mobileNumber  {
                    return newLength <= 12
                } else if heading == AppString.Heading.expectedAmount || heading == AppString.Heading.transactionAmount {
                    initialFieldString += string
                    print(initialFieldString)
                    formatCurrency(string: initialFieldString)
                    return newLength <= 10
                } else if heading == AppString.Heading.numbeerOfTransaction {
                    return newLength <= 5
                } else if heading == AppString.Heading.salePersonId {
                    return newLength <= 4
                }
                return true
            }
            return false
        } else if heading == AppString.Heading.branchName || heading == AppString.Heading.iban || heading == AppString.Heading.address || heading == AppString.Heading.currentAddress || heading == AppString.Heading.permanentAddress || heading == AppString.Heading.physicianName || heading == "Beneficiary Account Number / IBAN" {
            if heading == AppString.Heading.iban { return newLength <= 24 }
            return true
        } else if textField.keyboardType == .default {
            let allowedCharacter = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacter.isSuperset(of: characterSet)
        }
        return true
    }
}
