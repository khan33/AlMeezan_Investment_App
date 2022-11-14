//
//  HeaderView.swift
//  AlMeezan
//
//  Created by Atta khan on 15/11/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import Foundation
import UIKit


class HeaderView: UIView {
    
    // MARK: VIEW PROPERTIES
    
    private (set) lazy var containerView: UIView = {[unowned self] in
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .red
        return view
    }()
    private (set) lazy var imgView: UIImageView = { [unowned self] in
        var imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "top_bar")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    private (set) lazy var backBtn: UIButton = { [unowned self] in
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "BackArrow"), for: .normal)
        btn.contentMode = .scaleAspectFill
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        return btn
    }()

    private (set) lazy var lblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.textColor =  UIColor.rgb(red: 203, green: 148, blue: 212, alpha: 1)
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 11)
        return label
    }()
    private (set) lazy var subLblTitle: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        label.numberOfLines = 0
        return label
    }()
    private (set) lazy var nextBtn: UIButton = {[unowned self] in
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.setImage(UIImage(named: "chevron-down")?.transform(withNewColor: .white), for: .normal)
        view.tintColor = .white
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
        return view
    }()
    
    private (set) lazy var previousBtn: UIButton = {[unowned self] in
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.setImage(UIImage(named: "chevron-down")?.transform(withNewColor: .white), for: .normal)
        view.tintColor = .white
        view.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        view.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        view.addTarget(self, action: #selector(previousBtnPressed), for: .touchUpInside)
        return view
    }()
    
    private (set) lazy var lblStep: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1 / 9"
        label.textColor = UIColor.white
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 12)
        return label
    }()
    
    
    private (set) lazy var stackPagerView: UIStackView = { [unowned self] in
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 2
        view.clipsToBounds = true
        return view
    }()
    
    private var closeBtnAction: (() -> Void)!
    private var nextBtnAction: (() -> Void)!
    private var previousBtnAction: (() -> Void)!
    var numberOfPages = 4
    var currentPageNo = 0

    init(stepValue: String, titleStr: String, subTitle: String, numberOfPages: Int = 0, currentPageNo: Int = 0, closeAction: @escaping () -> Void, nextAction: @escaping () -> Void, previousAction: @escaping () -> Void) {
        super.init(frame: CGRect.zero)
        closeBtnAction = closeAction
        nextBtnAction = nextAction
        previousBtnAction = previousAction
        self.lblStep.text = stepValue
        self.lblTitle.text = titleStr
        
        if let splitString = subTitle.between("(", ")") {
            let attributedString = NSMutableAttributedString(string: subTitle)
            let range: NSRange = attributedString.mutableString.range(of: splitString, options: .caseInsensitive)
            attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 11), range: range)
            self.subLblTitle.attributedText = attributedString
        } else {
            self.subLblTitle.text = subTitle
        }
        
        self.numberOfPages = numberOfPages
        self.currentPageNo = currentPageNo
        setUpContainerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func setUpContainerView() {
        if !containerView.isDescendant(of: self) {
            self.addSubview(containerView)
        }
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 124.0).isActive = true
        
        if !imgView.isDescendant(of: containerView) {
            containerView.addSubview(imgView)
        }
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        if !backBtn.isDescendant(of: containerView) {
            containerView.addSubview(backBtn)
        }

        backBtn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant:  16).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 4).isActive = true
        backBtn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true

        if !lblTitle.isDescendant(of: containerView) {
            containerView.addSubview(lblTitle)
        }

        lblTitle.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 12).isActive = true
        lblTitle.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor, constant: -8).isActive = true

        if !subLblTitle.isDescendant(of: containerView) {
            containerView.addSubview(subLblTitle)
        }

        subLblTitle.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        subLblTitle.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 6).isActive = true
        subLblTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -80).isActive = true

        if !nextBtn.isDescendant(of: containerView) {
            containerView.addSubview(nextBtn)
        }
        nextBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0).isActive = true
        nextBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        
        if !previousBtn.isDescendant(of: containerView) {
            containerView.addSubview(previousBtn)
        }

        previousBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        previousBtn.trailingAnchor.constraint(equalTo: nextBtn.trailingAnchor, constant: -24).isActive = true

        if !lblStep.isDescendant(of: containerView) {
            containerView.addSubview(lblStep)
        }

        lblStep.topAnchor.constraint(equalTo: nextBtn.bottomAnchor, constant: 2).isActive = true
        lblStep.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -28).isActive = true
//        lblStep.leadingAnchor.constraint(equalTo: nextBtn.leadingAnchor, constant: -10).isActive = true

        
        if !stackPagerView.isDescendant(of: containerView) {
            containerView.addSubview(stackPagerView)
        }
        stackPagerView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        stackPagerView.leadingAnchor.constraint(equalTo: subLblTitle.leadingAnchor, constant: 0).isActive = true
        stackPagerView.topAnchor.constraint(equalTo: subLblTitle.bottomAnchor, constant: 8).isActive = true
        stackPagerView.widthAnchor.constraint(equalToConstant: CGFloat(numberOfPages) * 20.0).isActive = true
        
        pagerView(numberOfPages, currentPageNo)
        
    }
    
    func pagerView(_ pages: Int, _ currentPage: Int) {
        for i in 0..<pages {
            let view = createViews()
            if i == currentPage {
                view.layer.cornerRadius = 2
                view.alpha = 1
            } else {
                view.layer.cornerRadius = 4
                view.alpha = 0.5
            }
            stackPagerView.addArrangedSubview(view)
        }
    }
    @objc private
    func closePressed() {
        self.closeBtnAction()
    }
    
    @objc private
    func previousBtnPressed() {
        self.previousBtnAction()
    }
    @objc private
    func nextBtnPressed() {
        self.nextBtnAction()
    }
    
    func createViews() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: 6, height: 2)
        view.layer.cornerRadius = 4
        return view
    }
}
extension String {

    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            ,leftRange.upperBound <= rightRange.lowerBound else { return nil }

        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }

}
