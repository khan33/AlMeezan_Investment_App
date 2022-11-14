//
//  SuccessViewController.swift
//  AlMeezan
//
//  Created by Atta khan on 02/12/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import FirebaseAnalytics
class SuccessViewController: UIViewController {

    
    @IBOutlet weak var fbImageView: UIImageView!
    @IBOutlet weak var twitterImgView: UIImageView!
    @IBOutlet weak var instaImgView: UIImageView!
    @IBOutlet weak var youtubeImgView: UIImageView!
    @IBOutlet weak var linkdinImgView: UIImageView!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fbImageView.isUserInteractionEnabled = true
        twitterImgView.isUserInteractionEnabled = true
        instaImgView.isUserInteractionEnabled = true
        youtubeImgView.isUserInteractionEnabled = true
        linkdinImgView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(fbImgTapped))
        fbImageView.addGestureRecognizer(tapRecognizer)
        let tapRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(twitterImgTapped))
        twitterImgView.addGestureRecognizer(tapRecognizer1)
        
        let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(youtubeImgTapped))
        youtubeImgView.addGestureRecognizer(tapRecognizer2)
        
        let tapRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(instaImgTapped))
        instaImgView.addGestureRecognizer(tapRecognizer3)
        
        let tapRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(linkedinImgTapped))
        linkdinImgView.addGestureRecognizer(tapRecognizer4)
        
    }
    
    @objc func fbImgTapped(sender: UIImageView) {
        SocialNetwork.Facebook.openPage()
    }
    
    @objc func twitterImgTapped(sender: UIImageView) {
        SocialNetwork.Twitter.openPage()
    }
    @objc func youtubeImgTapped(sender: UIImageView) {
        SocialNetwork.Youtube.openPage()
    }
    
    @objc func instaImgTapped(sender: UIImageView) {
        SocialNetwork.Instagram.openPage()
    }
    
    @objc func linkedinImgTapped(sender: UIImageView) {
        SocialNetwork.Linkedin.openPage()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTaploginButton(_ sender: Any) {
        let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
//     info@almeezangroup.com or call us 0800-HALAL (42525) or +92 21 111 633 926
    @IBAction func didTapOnEmailBtn(_ sender: Any) {
        let appURL = URL(string: "mailto:info@almeezangroup.com")!

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(appURL)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Utility.shared.googleAnalyticsEvent(OnlineAccountEnums.STEP_EIGHT.index, OnlineAccountEnums.STEP_EIGHT.value, OnlineAccountEnums.STEP_EIGHT.screenName, String(describing: type(of: self)))
    }

    @IBAction func didTapOnCallUsBtn(_ sender: Any) {
        var rootViewContoller = UIApplication.shared.keyWindow?.rootViewController
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
    


    @IBAction func didTapOnPhoneBtn(_ sender: Any) {
        var rootViewContoller = UIApplication.shared.keyWindow?.rootViewController
        let phoneNumber = "+9221111633926" //"021 111 633 926
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: ("Call now on our mobile number +92 21 111 633 926"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            rootViewContoller?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    
    
}
