//
//  QuestionItemCell.swift
//  AlMeezan
//
//  Created by Atta khan on 06/01/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit
import DatePickerDialog

protocol QuestionAnswerProtocol: AnyObject {
    func getAnswer(row: Int, option: AnswerOption, answer: Bool)
    func getTxtFieldTxt(txt: String)
}

extension QuestionAnswerProtocol {
    func getTxtFieldTxt(txt: String) {
        
    }
}

class QuestionItemCell: UICollectionViewCell {
    
    weak var delegate: QuestionAnswerProtocol?
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor =  UIColor.rgb(red: 79, green: 90, blue: 101, alpha: 0.05)
        view.cornerReduis(reduis: 5, BGColor: .white, borderColor: .clear, borderWidth: 1)
        return view
    }()
    private (set) lazy var questionNo: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 0
        return label
    }()
    
    
    private (set) lazy var questionLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "High blood pressure, chest pain, stroke or any heart or circulatory trouble?"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 15)
        label.numberOfLines = 0
        return label
    }()
    
    private (set) lazy var yesRadioBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var yesLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Yes"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 1
        return label
    }()
    
    private (set) lazy var noLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 1
        return label
    }()
    
    private (set) lazy var noRadioBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnOptionBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var yesView: UIView = {[unowned self] in
        let view = UIView()
        return view
    }()
    
    private (set) lazy var noView: UIView = {[unowned self] in
        let view = UIView()
        return view
    }()
    
    
    lazy var txtField: UITextField = {[unowned self] in
        let view = UITextField()
        view.textAlignment = .left
        view.textColor = .black
        view.font = AppFonts.txtFieldFont
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.placeholder = "Enter your explaination"
        view.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        view.isHidden = true
        return view
    }()
    private (set) lazy var borderView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        view.isHidden = true
        return view
    }()
    
    
    private (set) lazy var stack: UIStackView = {[unowned self] in
        let view = UIStackView(arrangedSubviews: [yesView, noView])
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }()
    
    private (set) lazy var postiveView: UIView = {[unowned self] in
        let view = UIView()
        return view
    }()
    private (set) lazy var postiveRadioBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 1
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnCovidOptionBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var negativeView: UIView = {[unowned self] in
        let view = UIView()
        return view
    }()
    private (set) lazy var negativeRadioBtn: UIButton = { [unowned self] in
        let btn = UIButton()
        btn.tag = 0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "radio_button_unchecked"), for: .normal)
        btn.setImage(UIImage(named: "radio_button_checked"), for: .selected)
        btn.addTarget(self, action: #selector(didTapOnCovidOptionBtn), for: .touchUpInside)
        return btn
    }()
    
    private (set) lazy var covidStackView: UIStackView = {[unowned self] in
        let view = UIStackView(arrangedSubviews: [postiveView, negativeView])
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }()
    
    private (set) lazy var postiveLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Covid-19 Positive"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 1
        return label
    }()
    
    private (set) lazy var negativeLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Covid-19 Negative"
        label.textColor =  UIColor.init(rgb:0x232746)
        label.font = UIFont(name: AppFontName.robotoRegular, size: 13)
        label.numberOfLines = 1
        return label
    }()
    
    private (set) lazy var pickerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(didTapOnPickerBtn), for: .touchUpInside)
        return btn
    }()
    
    var indexRow: Int!
    var datePicker: DatePickerDialog!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        datePicker = DatePickerDialog(textColor: .black,
                                          buttonColor: .black,
                                          font: UIFont.boldSystemFont(ofSize: 14),
                                          showCancelButton: true)
        loadUIView()
        negativeRadioBtn.isSelected = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var quesiton_model: OptionModel? {
        didSet {
            if quesiton_model?.code == "other" {
                txtField.text = ""
                txtField.isHidden = false
                borderView.isHidden = false
                stack.isHidden = true
                covidStackView.isHidden = true
                pickerBtn.isHidden = true
                txtField.text = quesiton_model?.explaination
                if txtField.text != "" {
                    delegate?.getTxtFieldTxt(txt: txtField.text ?? "")
                }
            } else if quesiton_model?.code == "covid" {
                txtField.text = ""
                txtField.isHidden = false
                borderView.isHidden = false
                stack.isHidden = true
                covidStackView.isHidden = false
                pickerBtn.isHidden = false
                if let explaination = quesiton_model?.explaination {
                    let explainArray = explaination.split(separator: ",")
                    if explainArray.count > 1 {
                        let date = explainArray[0].split(separator: "T")
                        txtField.text = "\(date[0])"
                        if explainArray[1] == "POSITIVE" {
                            postiveRadioBtn.isSelected = true
                            negativeRadioBtn.isSelected = false
                        } else {
                            negativeRadioBtn.isSelected = true
                            postiveRadioBtn.isSelected = false
                        }
                    }
//
                }
                
                
            } else {
                txtField.text = ""
                txtField.isHidden = true
                borderView.isHidden = true
                covidStackView.isHidden = true
                pickerBtn.isHidden = true
                stack.isHidden = false
            }
                    
                    
            if let answer = quesiton_model?.answer {
                if answer == 1 {
                    yesRadioBtn.isSelected = true
                    noRadioBtn.isSelected = false
                } else {
                    yesRadioBtn.isSelected = false
                    noRadioBtn.isSelected = true
                }
                    
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
        
        if !yesRadioBtn.isDescendant(of: yesView) {
            yesView.addSubview(yesRadioBtn)
        }
        yesRadioBtn.centerYAnchor.constraint(equalTo: yesView.centerYAnchor).isActive = true
        yesRadioBtn.leadingAnchor.constraint(equalTo: yesView.leadingAnchor, constant: 8).isActive = true
        
        if !yesLbl.isDescendant(of: yesView) {
            yesView.addSubview(yesLbl)
        }
        yesLbl.centerYAnchor.constraint(equalTo: yesView.centerYAnchor).isActive = true
        yesLbl.leadingAnchor.constraint(equalTo: yesRadioBtn.trailingAnchor, constant: 8).isActive = true

        if !noRadioBtn.isDescendant(of: noView) {
            noView.addSubview(noRadioBtn)
        }
        noRadioBtn.centerYAnchor.constraint(equalTo: noView.centerYAnchor).isActive = true
        noRadioBtn.leadingAnchor.constraint(equalTo: noView.leadingAnchor, constant: 8).isActive = true

        if !noLbl.isDescendant(of: noView) {
            noView.addSubview(noLbl)
        }
        noLbl.centerYAnchor.constraint(equalTo: noView.centerYAnchor).isActive = true
        noLbl.leadingAnchor.constraint(equalTo: noRadioBtn.trailingAnchor, constant: 8).isActive = true
        
        if !stack.isDescendant(of: containerView) {
            containerView.addSubview(stack)
        }
        stack.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 8).isActive = true
        stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
//
//
        if !txtField.isDescendant(of: containerView) {
            containerView.addSubview(txtField)
        }
        txtField.text = ""
        txtField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        txtField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        txtField.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 4).isActive = true
        txtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        if !borderView.isDescendant(of: containerView) {
            containerView.addSubview(borderView)
        }
        borderView.topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 2).isActive = true
        borderView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        borderView.leadingAnchor.constraint(equalTo: txtField.leadingAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: txtField.trailingAnchor).isActive = true
        
        
        
        if !pickerBtn.isDescendant(of: containerView) {
            containerView.addSubview(pickerBtn)
        }
        pickerBtn.leadingAnchor.constraint(equalTo: txtField.leadingAnchor, constant: 0).isActive = true
        pickerBtn.trailingAnchor.constraint(equalTo: txtField.trailingAnchor, constant: 0).isActive = true
        pickerBtn.topAnchor.constraint(equalTo: txtField.topAnchor, constant: 0).isActive = true
        pickerBtn.bottomAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 0).isActive = true
        
        
        if !postiveRadioBtn.isDescendant(of: postiveView) {
            postiveView.addSubview(postiveRadioBtn)
        }
        postiveRadioBtn.centerYAnchor.constraint(equalTo: postiveView.centerYAnchor).isActive = true
        postiveRadioBtn.leadingAnchor.constraint(equalTo: postiveView.leadingAnchor, constant: 8).isActive = true
        
        if !postiveLbl.isDescendant(of: postiveView) {
            postiveView.addSubview(postiveLbl)
        }
        postiveLbl.centerYAnchor.constraint(equalTo: postiveView.centerYAnchor).isActive = true
        postiveLbl.leadingAnchor.constraint(equalTo: postiveRadioBtn.trailingAnchor, constant: 8).isActive = true

        if !negativeRadioBtn.isDescendant(of: negativeView) {
            negativeView.addSubview(negativeRadioBtn)
        }
        negativeRadioBtn.centerYAnchor.constraint(equalTo: negativeView.centerYAnchor).isActive = true
        negativeRadioBtn.leadingAnchor.constraint(equalTo: negativeView.leadingAnchor, constant: 8).isActive = true

        if !negativeLbl.isDescendant(of: negativeView) {
            negativeView.addSubview(negativeLbl)
        }
        negativeLbl.centerYAnchor.constraint(equalTo: negativeView.centerYAnchor).isActive = true
        negativeLbl.leadingAnchor.constraint(equalTo: negativeRadioBtn.trailingAnchor, constant: 8).isActive = true
        
        if !covidStackView.isDescendant(of: containerView) {
            containerView.addSubview(covidStackView)
        }
        covidStackView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: 8).isActive = true
        covidStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        covidStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        covidStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    @objc func didTapOnOptionBtn(_ sender: UIButton) {
        if sender.tag == 0 {
            noRadioBtn.isSelected = true
            yesRadioBtn.isSelected = false
            delegate?.getAnswer(row: indexRow, option: AnswerOption.no, answer: false)
        } else {
            noRadioBtn.isSelected = false
            yesRadioBtn.isSelected = true
            delegate?.getAnswer(row: indexRow, option: AnswerOption.yes, answer: true)
        }
    }
    @objc private func textFieldDidChange(textField: UITextField) {
        textField.text = textField.text?.uppercased()
        delegate?.getTxtFieldTxt(txt: textField.text ?? "")
        //enterTextCloser(textField.text ?? "")
    }
    
    @objc func didTapOnCovidOptionBtn(_ sender: UIButton) {
        if sender.tag == 0 {
            negativeRadioBtn.isSelected = true
            postiveRadioBtn.isSelected = false
            var info = [String: String]()
            info["result"] = "Negative"
            NotificationCenter.default.post(name: Notification.Name(rawValue: "result"), object: nil, userInfo: info)
        } else {
            negativeRadioBtn.isSelected = false
            postiveRadioBtn.isSelected = true
            var info = [String: String]()
            info["result"] = "Positive"
            NotificationCenter.default.post(name: Notification.Name(rawValue: "result"), object: nil, userInfo: info)
        }
    }
    
    @objc func didTapOnPickerBtn() {
        
        var dateComponents = DateComponents()
        dateComponents.year = -100
        let minDate = Calendar.current.date(byAdding: dateComponents, to: Date() )
        dateComponents.year = 0
        let maxDate = Calendar.current.date(byAdding: dateComponents, to: Date())
        self.datePicker.show("Date Picker",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        defaultDate: Date(),
                        minimumDate: minDate,
                        maximumDate: maxDate,
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                let dateValue = formatter.string(from: dt)
                                self.txtField.text = dateValue
                                var info = [String: String]()
                                info["picker"] = dateValue
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "date Picker"), object: nil, userInfo: info)
                            } else {
                                self.txtField.text = ""
                            }
        }
    }
}
