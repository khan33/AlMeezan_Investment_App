//
//  ETransactionWebViewVC.swift
//  AlMeezan
//
//  Created by Atta khan on 08/09/2020.
//  Copyright © 2020 Atta khan. All rights reserved.
//

import UIKit
import SVProgressHUD


protocol Transaction {
    func continueTransaction(_ fundTxt: String?, _ amount: String?)
}

class ETransactionWebViewVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var blurView: UIView!
    var highRisk: [HighRskModel]?
    var clickedURL: String?
    var delegate: Transaction?
    var fundTxt: String = ""
    var amount: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = ""
        self.textView.delegate = self
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.redirectScreen), name: .openURL, object: nil)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.blurView.addGestureRecognizer(gesture)
    }
    @objc func checkAction(sender : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnCancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapOnOKBtn(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.continueTransaction(self.fundTxt, self.amount)
        }
        navigationController?.popViewController(animated: true)
    }
    func getData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: HIGHT_TEXT)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "High risk", modelType: HighRskModel.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            //self.showErrorMsg(errorMessage)
        }, success: { (response) in
            print(response)
            self.highRisk = response
            self.textView.attributedText = self.highRisk?[0].text?.htmlToAttributedString

        }, fail: { (error) in
            print(error.localizedDescription)
            self.showAlert(title: "Alert", message: "The Internet connection appears to be offline.", controller: self) {
            }
            
        }, showHUD: true)
    }
    @objc func redirectScreen() {
        if let url = clickedURL {
            let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
            vc.urlStr = url
            vc.titleStr = "High Risk Fund"
            vc.isTransition = false
            vc.isPresentView = true
            present(vc, animated: true, completion: nil)
            //navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    

}
extension ETransactionWebViewVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("click event url:", URL)
        clickedURL = URL.absoluteString
        NotificationCenter.default.post(name: .openURL, object: nil)
        return false
    }
}
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
