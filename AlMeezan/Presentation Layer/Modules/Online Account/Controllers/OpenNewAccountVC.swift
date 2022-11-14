//
//  OpenNewAccountVC.swift
//  AlMeezan
//
//  Created by Atta khan on 16/03/2021.
//  Copyright © 2021 Atta khan. All rights reserved.
//

import UIKit

class OpenNewAccountVC: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var innerView2: UIView!
    @IBOutlet weak var innerView1: UIView!
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var innerView3: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let txt = "Basic Account with access to all funds. Per transaction limit of max Rs.\u{00a0}400,000, max annual limit of Rs.\u{00a0}800,000 & cumulative limit of Rs.\u{00a0}1,000,000."
        label1.text = txt
        
        
        view1.roundCornersWithoutShadow([.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 24, borderColor: .lightGray, borderWidth: 0.5)
        view2.roundCornersWithoutShadow([.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 24, borderColor: .lightGray, borderWidth: 0.5)
        view3.roundCornersWithoutShadow([.layerMinXMinYCorner,.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 24, borderColor: .lightGray, borderWidth: 0.5)
        
        
        innerView1.roundCornersWithoutShadow([.layerMinXMinYCorner], radius: 24, borderColor: .lightGray, borderWidth: 0)
        innerView2.roundCornersWithoutShadow([.layerMinXMinYCorner], radius: 24, borderColor: .lightGray, borderWidth: 0)
        innerView3.roundCornersWithoutShadow([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 24, borderColor: .lightGray, borderWidth: 0)
        
        button1.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        button2.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        button3.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func didTapNotificationBtn(_ sender: Any) {
    }
    
    
    @IBAction func didTapSahulatAccount(_ sender: Any) {
        UserDefaults.standard.setValue(OnlineAccountType.SSA.rawValue, forKey: "OnlineAccountType")
        let vc = OTPViewController()
        OTPViewControllerConfigurator.configureModule(viewController: vc)
        
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func didTapRoshanAccount(_ sender: Any) {
        let vc = RDAViewController.instantiateFromAppStroyboard(appStoryboard: .onlineAccount)
        navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func didTapDigitalAccount(_ sender: Any) {
        UserDefaults.standard.setValue(OnlineAccountType.digital.rawValue, forKey: "OnlineAccountType")
        let vc = OTPViewController()
        OTPViewControllerConfigurator.configureModule(viewController: vc)
        navigationController?.pushViewController(vc, animated: false)
    }
    
}
enum OnlineAccountType: String {
    case digital = "DGT"
    case SSA =  "SSA"
}
