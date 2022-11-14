//
//  ThankYouViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 11/02/2022.
//  Copyright © 2022 Atta khan. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController {
    private (set) lazy var headerView: HeaderView = { [unowned self] in
        let view = HeaderView.init(stepValue: "9 / 9", titleStr: "Submission", subTitle: "Thank You" ,numberOfPages: 0, currentPageNo: 0, closeAction: {
            self.navigationController?.popViewController(animated: true)
        }, nextAction: {
            print("next")
        }, previousAction: {
            self.navigationController?.popViewController(animated: true)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backBtn.isHidden = true
        view.previousBtn.isHidden = true
        view.nextBtn.isHidden = true
        view.lblStep.isHidden = true
        return view
    }()
    
    private (set) lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "Al Meezan LOGO-1")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private (set) lazy var messageLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Thank you for showing interest in Al Meezan Investments. Your account opening request is in process. You will be notified within 1 working day for further steps."
        label.textColor =  UIColor.init(rgb:0x232746)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 15)
        return label
    }()
    
    private (set) lazy var callLbl: UILabel = { [unowned self] in
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = "For details please call \n 0800-HALAL (42525) \n or email at \n info@almeezangroup.com."
        label.textColor =  UIColor.init(rgb:0x232746)
        label.numberOfLines = 0
        label.font = UIFont(name: AppFontName.circularStdRegular, size: 13)
        label.textAlignment = .center
        return label
    }()
    
    
    private (set) lazy var fbImgView: SocialButton = {
        let imgViewBtn = SocialButton()
        imgViewBtn.setImage(UIImage(named: "facebook-circular-logo"), for: .normal)
        imgViewBtn.addTarget(self, action: #selector(didTapOnSocialBtn), for: .touchUpInside)
        imgViewBtn.type = .Facebook
        return imgViewBtn
    }()
    
    private (set) lazy var twitterImgView: SocialButton = {
        let imgViewBtn = SocialButton()
        imgViewBtn.setImage(UIImage(named: "twitter"), for: .normal)
        imgViewBtn.addTarget(self, action: #selector(didTapOnSocialBtn), for: .touchUpInside)
        imgViewBtn.type = .Twitter
        return imgViewBtn
    }()
    
    private (set) lazy var InstaImgView: SocialButton = {
        let imgViewBtn = SocialButton()
        imgViewBtn.setImage(UIImage(named: "instagram"), for: .normal)
        imgViewBtn.addTarget(self, action: #selector(didTapOnSocialBtn), for: .touchUpInside)
        imgViewBtn.type = .Instagram
        return imgViewBtn
    }()
    
    
    private (set) lazy var youtubeImgView: SocialButton = {
        let imgViewBtn = SocialButton()
        imgViewBtn.setImage(UIImage(named: "youtubeIcon"), for: .normal)
        imgViewBtn.addTarget(self, action: #selector(didTapOnSocialBtn), for: .touchUpInside)
        imgViewBtn.type = .Youtube
        return imgViewBtn
    }()
    
    
    private (set) lazy var linkedinImgView: SocialButton = {
        let imgViewBtn = SocialButton()
        imgViewBtn.setImage(UIImage(named: "linkedin"), for: .normal)
        imgViewBtn.addTarget(self, action: #selector(didTapOnSocialBtn), for: .touchUpInside)
        imgViewBtn.type = .Linkedin
        return imgViewBtn
    }()
    
    private (set) lazy var stackView: UIStackView = { [unowned self] in
        let view = UIStackView(arrangedSubviews: [fbImgView, twitterImgView, InstaImgView, youtubeImgView, linkedinImgView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 16
        view.clipsToBounds = true
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        self.callLbl.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        tapgesture.numberOfTouchesRequired = 1
        self.callLbl.addGestureRecognizer(tapgesture)
        self.callLbl.isUserInteractionEnabled = true
        
        
        let string = "For details please call\n\n0800-HALAL(42525)\n\n+92 21 111 633 926\n\nor email at\n\ninfo@almeezangroup.com"
        let attributedString = NSMutableAttributedString(string: string)
        
        let range: NSRange = attributedString.mutableString.range(of: "0800-HALAL(42525)", options: .caseInsensitive)
        
        attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 16), range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x4F5A65), range: range)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range)
        
        let range2: NSRange = attributedString.mutableString.range(of: "+92 21 111 633 926", options: .caseInsensitive)
        attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoMedium, size: 16), range: range2)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x4F5A65), range: range2)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: range2)
        
        
        let range1: NSRange = attributedString.mutableString.range(of: "info@almeezangroup.com", options: .caseInsensitive)
        attributedString.addAttribute(.font, value: UIFont(name: AppFontName.robotoRegular, size: 13), range: range1)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(rgb: 0x0000FF), range: range1)
        
        
        callLbl.attributedText = attributedString
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = self.callLbl.text else { return }
        let callUSRange = (text as NSString).range(of: "0800-HALAL(42525)")
        let IntlcallUSRange = (text as NSString).range(of: "+92 21 111 633 926")
        let emailUSRange = (text as NSString).range(of: "info@almeezangroup.com")
        if gesture.didTapAttributedTextInLabel(label: self.callLbl, inRange: callUSRange) {
            callUS()
        } else if gesture.didTapAttributedTextInLabel(label: self.callLbl, inRange: IntlcallUSRange) {
            InternationCall()
        }
        else if gesture.didTapAttributedTextInLabel(label: self.callLbl, inRange: emailUSRange) {
            emailUS()
        } else {
            print("false")
        }

    }
    
    private func emailUS() {
        let appURL = URL(string: "mailto:info@almeezangroup.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL)
        }
    }
    
    private func callUS() {
        let rootViewContoller = UIApplication.shared.keyWindow?.rootViewController
        let phoneNumber = "080042525" //"021 111 633 926
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            let alert = UIAlertController(title: ("Call us now on our toll free number at 0800-HALAL (42525)"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            rootViewContoller?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func InternationCall() {
        let rootViewContoller = UIApplication.shared.keyWindow?.rootViewController
        let phoneNumber = "9221111633926" //"021 111 633 926
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            let alert = UIAlertController(title: ("Call us on  +92 21 111 633 926"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            rootViewContoller?.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func didTapOnSocialBtn(_ sender: SocialButton) {
        let type = sender.type
        switch type {
        case .Facebook:
            SocialNetwork.Facebook.openPage()
        case .Linkedin:
            SocialNetwork.Linkedin.openPage()
        case .Twitter:
            SocialNetwork.Twitter.openPage()
        case .Youtube:
            SocialNetwork.Youtube.openPage()
        case .Instagram:
            SocialNetwork.Instagram.openPage()
        case .none:
            return
        }
    }
    
    fileprivate func setupViews() {
        self.view.backgroundColor = UIColor.init(rgb: 0xF4F6FA)
        
        if !headerView.isDescendant(of: self.view) {
            self.view.addSubview(headerView)
        }
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 124.0).isActive = true
 
        if !imgView.isDescendant(of: self.view) {
            self.view.addSubview(imgView)
        }
        imgView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor, constant: 24).isActive = true
        imgView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        
        if !messageLbl.isDescendant(of: self.view) {
            self.view.addSubview(messageLbl)
        }
        messageLbl.topAnchor.constraint(equalTo: self.imgView.bottomAnchor, constant: 24).isActive = true
        messageLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        messageLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24).isActive = true
        
        if !callLbl.isDescendant(of: self.view) {
            self.view.addSubview(callLbl)
        }
        callLbl.topAnchor.constraint(equalTo: self.messageLbl.bottomAnchor, constant: 24).isActive = true
        callLbl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        if !stackView.isDescendant(of: self.view) {
            self.view.addSubview(stackView)
        }
        stackView.topAnchor.constraint(equalTo: self.callLbl.bottomAnchor, constant: 24).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 44).isActive = true
        stackView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        let btnView = CenterButtonView.init(title: "BACK TO HOME") { [weak self] (clicked) in
            guard let self = self else {return}
            self.navigationController?.popToRootViewController(animated: true)
        }
        btnView.translatesAutoresizingMaskIntoConstraints = false
        btnView.clipsToBounds = true
        if !btnView.isDescendant(of: view) {
            view.addSubview(btnView)
        }
        //btnView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        btnView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        btnView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        btnView.containerView.backgroundColor = UIColor.init(rgb: 0xF4F6FA)
    }
}
extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        return NSLocationInRange(indexOfCharacter, targetRange)
    }
        
}

class SocialButton: UIButton {
    var type: SocialNetwork?
}
