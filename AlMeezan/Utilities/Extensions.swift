//
//  Extension.swift
//  AlMeezan
//
//  Created by Atta khan on 30/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import PKRevealController
import SwiftKeychainWrapper
import SVProgressHUD

extension UITableView {
    func registerCells(_ cells: [UITableViewCell.Type]) {
        cells.forEach({ register(UINib(nibName: String(describing: $0), bundle: nil), forCellReuseIdentifier: String(describing: $0)) })
    }
    
    func registerHeaderFooter(_ headerFooter: [UITableViewHeaderFooterView.Type]) {
        headerFooter.forEach({ register(UINib(nibName: String(describing: $0), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: $0)) })
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(with type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as? T
    }
}

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func instantiateFromAppStroyboard(appStoryboard: AppStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    func showNotification(with message: String?, viewss : UIView ,  autoDismiss: Bool = true,   handler: (() -> ())? = nil) {
        let notificationLabel = UILabel()
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationLabel.text = message
        notificationLabel.textColor = .black
        notificationLabel.textAlignment = .center
        notificationLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        notificationLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        notificationLabel.numberOfLines = 0
        
        guard let navigationController = navigationController else { return }
        
        //        let subviews = navigationController.navigationBar.subviews.filter({ $0 is UILabel })
        
        let subviews = viewss.subviews.filter({$0 is UILabel})
        
        //        navigationController.navigationBar.insertSubview(notificationLabel, at: subviews.count > 0 ? subviews.count : 0)
        self.view.insertSubview(notificationLabel, at: subviews.count > 0 ? subviews.count : 0)
        notificationLabel.centerXAnchor.constraint(equalTo: viewss.centerXAnchor).isActive = true
        notificationLabel.topAnchor.constraint(equalTo: viewss.bottomAnchor).isActive = true
        notificationLabel.widthAnchor.constraint(equalTo: viewss.widthAnchor).isActive = true
        notificationLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true
        
        notificationLabel.sizeToFit()
        
        notificationLabel.transform = CGAffineTransform(translationX: 0, y: -notificationLabel.frame.height)
        
        UIView.animate(withDuration: 0.25) {
            notificationLabel.transform = .identity
        }
        
        if autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.25, animations: {
                    notificationLabel.alpha = 0
                    notificationLabel.transform = CGAffineTransform(translationX: 0, y: -notificationLabel.frame.height)
                }, completion: { (done) in
                    notificationLabel.removeFromSuperview()
                    handler?()
                })
            }
        }
    }
    
    func showAlert(title: String, message: String, controller: UIViewController?, dismissCompletion:@escaping (AlertViewDismissHandler)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        //        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))
        if controller != nil {
            controller?.present(alert, animated: true, completion: nil)
        }else {
            present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func showConfirmationAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { action -> Void in
            //Do some other stuff
            
        }))
        alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))
        
        
        present(alertController, animated: true, completion:nil)
    }
    
    func LogoutOption() {
        let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
        self.navigationController?.pushViewController(vc, animated: false)
        Utility.shared.logout()
        
    }
    
    
    func showAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Login", style: .default, handler: { action -> Void in
            self.LogoutOption()
            dismissCompletion()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            self.LogoutOption()
            dismissCompletion()
        }))
        
        present(alertController, animated: true, completion:nil)
    }
    
    
    @IBAction func popController(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    func showNavigationBar() {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func showErrorMsg(_ errorMessage: [ErrorResponse]) {
        print(errorMessage.count)
        
        if errorMessage.count == 1 {
            if let errorID = errorMessage[0].errID {
                if errorID == "103" {
                    self.showAlertViewWithTitle(title: "Error", message: "Your session has been expired. Please login again.") {
                        KeychainWrapper.standard.set("ibex", forKey: "CustomerId")
                        KeychainWrapper.standard.set("_!b3xGl0b@L", forKey: "AccessToken")
                        KeychainWrapper.standard.set("anonymous", forKey: "UserType")
                    }
                } else {
                    let message = showErrorMessage(errorID)
                    self.showAlert(title: "Alert", message: message, controller: self) {
                        
                    }
                }
            }
        }
    }
    func loginOption() {
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
               self.showConfirmationAlertViewWithTitle(title: "Alert", message: Message.logoutConfirmationMsg) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = ViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                    vc.isFromSideMenu = false
                    self.navigationController?.pushViewController(vc, animated: false)
                    Utility.shared.logout()
                }
            } else {
                let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
                LoginConfigurator.configureModule(viewController: vc)
                navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    
    func navigateToController(_ selectedMenuItem: Int) {
        if let userAuth = KeychainWrapper.standard.string(forKey: "UserType") {
            if userAuth == "loggedInUser" {
                navigateControllerForLoggedInUser(selectedMenuItem)
            } else {
                navigateAnomoyusUser(selectedMenuItem)
            }
        }
    }
    
    func navigateAnomoyusUser(_ selectedMenuItem: Int) {
        if selectedMenuItem == 0 {
            let vc = MarketWatchVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 1 {
            let vc = InvestmentProductsVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 2 {
            let vc = WhereInvestVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 3 {
            let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
            vc.urlStr = FUND_REPORTS
            vc.titleStr = "Fund Performance"
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 4 {
            let vc = InvestmentEducationVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 5 {
            let vc = LoginViewController.instantiateFromAppStroyboard(appStoryboard: .home)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func navigateControllerForLoggedInUser(_ selectedMenuItem: Int) {
        if selectedMenuItem == 8 {
            let vc = DashboardViewController.instantiateFromAppStroyboard(appStoryboard: .home)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if selectedMenuItem == 0 {
            let vc = NewsFeedVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
        }else if selectedMenuItem == 1 {
            let vc = MarketWatchVC.instantiateFromAppStroyboard(appStoryboard: .marketWatch)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 2 {
            let vc = InvestmentProductsVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
            
        } else if selectedMenuItem == 3 {
            let vc = WhereInvestVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 4 {
            
            let vc = PaymentServicesVC()
            PaymentServiceConfigurator.configureModule(viewController: vc)
            self.navigationController?.pushViewController(vc, animated: true)
        
        } else if selectedMenuItem == 5 {
            let vc = BlogsViewController.instantiateFromAppStroyboard(appStoryboard: .main)
            vc.urlStr = FUND_REPORTS
            vc.titleStr = "Fund Performance"
            navigationController?.pushViewController(vc, animated: true)
            
        } else if selectedMenuItem == 6 {
            let vc = InvestmentEducationVC.instantiateFromAppStroyboard(appStoryboard: .main)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 7 {
            let vc = ProfileDetailsVC.instantiateFromAppStroyboard(appStoryboard: .home)
            navigationController?.pushViewController(vc, animated: true)
        } else if selectedMenuItem == 8 {
            self.showConfirmationAlertViewWithTitle(title: "Alert", message: Message.logoutConfirmationMsg) {
                let vc = ViewController.instantiateFromAppStroyboard(appStoryboard: .main)
                self.navigationController?.pushViewController(vc, animated: false)
                Utility.shared.logout()
            }
        }
    }
    
    
    func navigateToSpecificController(_ storyboard: UIStoryboard, _ identifier: String, controller: UIViewController?) -> UIViewController {
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height-100, width: (self.view.frame.width - 10), height: 35))
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    func showLoader() {
        SVProgressHUD.show()
    }
    func hideLoader() {
        SVProgressHUD.dismiss()
    }
    
}


extension UINavigationController {
    func backToViewController(viewController: Swift.AnyClass) {
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}



extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
    
}

extension UITextView :UITextViewDelegate{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

extension UIImageView {
    
    
    func setImage(with urlString: String?, placeholder: UIImage? = nil) {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        //        activityIndicator.center = placeholder.center
        activityIndicator.hidesWhenStopped = true
        //        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.startAnimating()
        
        self.image = placeholder
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        image = nil
        //        showLoading()
        
        let cache = URLCache.shared
        
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            //            hideLoading()
            self.image = image
        }
        else {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let this = self else { return }
                if let response = response, let data = data {
                    let image = UIImage(data: data)
                    
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        
                        //                        this.hideLoading()
                        this.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        
                        //                        this.hideLoading()
                        this.image = placeholder
                    }
                }
            }
            dataTask.resume()
        }
    }
}
extension UIColor {
    static var placeholderGray: UIColor {
        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
    static var placeholderErrorColor: UIColor {
        return UIColor.red
    }
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    static let pNavigationBarColor  =   UIColor(red: 138.0/255.0, green: 38.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    static let pSelectedBarColor    =   UIColor.init(rgb: 0xb332c9).withAlphaComponent(0.1)
    static let menuLblColor         =   UIColor.init(rgb: 0x5B5F78)
    static let themeLblColor        =   UIColor(red: 35.0/255.0, green: 39.0/255.0, blue: 70.0/255.0, alpha: 1.0)
    static let themeColor           =   UIColor(red: 138.0/255.0, green: 38.0/255.0, blue: 155.0/255.0, alpha: 1.0)
    static let colorOne             =   UIColor(red: 114.0/255.0, green: 31.0/255.0, blue: 129.0/255.0, alpha: 1.0)
    static let colorTwo             =   UIColor(red: 207.0/255.0, green: 92.0/255.0, blue: 228.0/255.0, alpha: 1.0)
    static let placeHolderColor     =   UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)
    static let statusColor      = UIColor.init(rgb: 0xF4F6FA)
    static let progressBarActiveColor      = UIColor.init(rgb: 0x008641)
    static let progressBarinActiveColor      = UIColor.init(rgb: 0xB262BF)
    
//    static var placeHolderColor: UIColor {
//        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
//    }
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat ) -> UIColor{
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
}
extension UIView{
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder (toside side: ViewSide, withColor color: CGColor, addThickness thickness: CGFloat ) {
        let border = CALayer()
        border.backgroundColor = color
        switch side {
            case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
            case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
                
            case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
            case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
        }
        layer.addSublayer(border)
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, paddingTop: CGFloat, bottom: NSLayoutYAxisAnchor?, paddingBottom: CGFloat, left: NSLayoutXAxisAnchor?, paddingLeft: CGFloat, right: NSLayoutXAxisAnchor?, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    func roundCorners1(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        
        self.layer.setGradientBackground(corners, radius: radius, colorOne: UIColor.red, colorTwo: UIColor.black)
        self.layer.applySketchShadow(color: .lightGray, alpha: 0.5, x: 0, y: 0, blur: 24, spread: 1)
        //applyGradient(colors: [UIColor.themeColor, UIColor.statusColor], locations: <#T##[NSNumber]?#>, direction: <#T##Direction#>)
        
    }
    
    func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
        self.layer.applySketchShadow(color: .lightGray, alpha: 0.5, x: 0, y: 0, blur: 24, spread: 1)
    }
    
    func roundCornersWithoutShadow(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.layer.maskedCorners = corners
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
    
    func dropShadowAllSides(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 0, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
   
    func animShow(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveEaseIn],
                       animations: {
                        //self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        //self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
    
    class func image(view: UIView, subview: UIView? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
            view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        if(subview != nil){
        var rect = (subview?.frame)!
                    rect.size.height *= image.scale  //MOST IMPORTANT
                    rect.size.width *= image.scale    //TOOK ME DAYS TO FIGURE THIS OUT
                    let imageRef = image.cgImage!.cropping(to: rect)
                    image = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
                }
        return image
        
    }
    func image() -> UIImage? {
        return UIView.image(view: self)
    }
    func image(withSubview: UIView) -> UIImage? {
        return UIView.image(view: self, subview: withSubview)
    }
    enum Direction: Int {
            case topToBottom = 0
            case bottomToTop
            case leftToRight
            case rightToLeft
        }
    func applyGradient(colors: [Any]?, locations: [NSNumber]? = [0.0, 1.0], direction: Direction = .topToBottom) {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = colors
            gradientLayer.locations = locations
            
            switch direction {
                case .topToBottom:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
                    
                case .bottomToTop:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
                    
                case .leftToRight:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                    
                case .rightToLeft:
                    gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            }
            
            self.layer.addSublayer(gradientLayer)
        }
    
    func cornerReduis(reduis:Int,BGColor:UIColor,borderColor:UIColor?,borderWidth:Double){
        self.layer.cornerRadius = CGFloat(reduis)
        self.layer.backgroundColor = backgroundColor?.cgColor
        self.layer.borderColor = borderColor?.cgColor
        self.layer.borderWidth = CGFloat(borderWidth)
        self.clipsToBounds = true
    }
    
    
}


extension CALayer{
    
    func removeShadow() {
        shadowOffset = .zero
        shadowColor = UIColor.clear.cgColor
        cornerRadius = 0
        shadowRadius = 0
        shadowOpacity = 0
    }
    func setGradientBackground(_ corners: CACornerMask, radius: CGFloat, colorOne: UIColor, colorTwo: UIColor) {
        //removeShadow()
        let gradientLayer = CAGradientLayer()
        gradientLayer.cornerRadius = radius
        gradientLayer.maskedCorners = corners
        gradientLayer.borderWidth = 0.5
        gradientLayer.borderColor = UIColor.lightGray.cgColor
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        //gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        insertSublayer(gradientLayer, at: 0)
    }
    
    
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 3, blur: CGFloat = 16, spread: CGFloat = 0) {
        //removeShadow()
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
    }
}
extension String {
    var isValidIBAN: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^[A-Za-z]{2}[0-9]{2}[A-Za-z]{4}[0-9]{16}$").evaluate(with: self)
    }
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    var isValidMobileNo: Bool {
        NSPredicate(format: "SELF MATCHES %@", "^((\\+92)|(0092)|(92))-{0,1}\\d{3}-{0,1}\\d{7}$|^\\d{11}$|^\\d{4}-\\d{7}").evaluate(with: self)
        
        //^\\+(?:[0-9]?){6,14}[0-9]$
        //^((\+92)|(0092))-{0,1}\d{3}-{0,1}\d{7}$|^\d{11}$|^\d{4}-\d{7}
    }
    
   
    struct NumFormatter {
         static let instance = NumberFormatter()
     }

     var doubleValue: Double? {
         return NumFormatter.instance.number(from: self)?.doubleValue
     }

     var integerValue: Int? {
         return NumFormatter.instance.number(from: self)?.intValue
     }
    
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss")-> Date?{
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(identifier: "Asia/Karachi")
//        dateFormatter.locale = Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)   
        return date
    }
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = 2
        if let intValue = Int(self) {
            return numberFormatter.string(from: NSNumber(value: intValue)) ?? "0"
        }
        if let value = Double(self){
            let number = numberFormatter.string(from: NSNumber(value: value)) ?? "0.0"
            return number
        }
        return ""
    }

    func toCurrencyFormat(withFraction fraction: Bool) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .down
        numberFormatter.numberStyle = .decimal
        if fraction {
            numberFormatter.minimumFractionDigits = 2
        }
        if let intValue = Int(self) {
            return numberFormatter.string(from: NSNumber(value: intValue)) ?? "0"
        }
        if let value = Double(self){
            let number = numberFormatter.string(from: NSNumber(value: value)) ?? "0.0"
            return number
        }
      return ""
    }
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    
    func components(withLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
    
}
extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}
extension Float {
    
    var kmFormatted: String {
        if self >= 10000, self <= 999999 {
            return String(format: "%.1fk", locale: Locale.current, self/1000).replacingOccurrences(of: ".0", with: "")
        }
        if self >= 999999, self <= 99999999{
            return String(format: "%.1fM", locale: Locale.current, self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        if self >= 99999999 {
            return String(format: "%.1fB", locale: Locale.current, self/1000000000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.0f", locale: Locale.current, self)
    }
}
extension Double {
    
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
    var kmFormatted: String {
        
        if self >= 10000, self <= 999999 {
            return String(format: "%.2fk", locale: Locale.current, self/1000).replacingOccurrences(of: ".0", with: "")
        }
        if self >= 999999, self <= 999999999 {
            return String(format: "%.2fM", locale: Locale.current, self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        if self >= 999999999 {
            return String(format: "%.2fB", locale: Locale.current, self/1000000000).replacingOccurrences(of: ".0", with: "")
        }
        return String(format: "%.2f", locale: Locale.current, self)
    }
    
}
extension Date {
    var age: Int { Calendar.current.dateComponents([.year], from: self, to: Date()).year! }
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return nextDate ?? Date()
    }
    
    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return previousDate ?? Date()
    }
    
    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
    func timeSinceDate(fromDate: Date) -> String {
        let earliest = self < fromDate ? self  : fromDate
        let latest = (earliest == self) ? fromDate : self
        
        let components:DateComponents = Calendar.current.dateComponents([.minute,.hour,.day,.weekOfYear,.month,.year,.second], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        
        if year >= 2{
            return "\(year) years ago"
        }else if (year >= 1){
            return "1 year ago"
        }else if (month >= 2) {
            return "\(month) months ago"
        }else if (month >= 1) {
            return "1 month ago"
        }else  if (week >= 2) {
            return "\(week) weeks ago"
        } else if (week >= 1){
            return "1 week ago"
        } else if (day >= 2) {
            return "\(day) days ago"
        } else if (day >= 1){
            return "1 day ago"
        } else if (hours >= 2) {
            return "\(hours) hours ago"
        } else if (hours >= 1){
            return "1 hour ago"
        } else if (minutes >= 2) {
            return "\(minutes) minutes ago"
        } else if (minutes >= 1){
            return "1 minute ago"
        } else if (seconds >= 3) {
            return "\(seconds) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
extension UILabel {
    func adjustsFontSizeForLbl() {
        minimumScaleFactor = 0.5    //or whatever suits your need
        adjustsFontSizeToFitWidth = true
        numberOfLines = 1
    }
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: self.font.pointSize) }
    }
    
}
extension UISegmentedControl {
    
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 11), color: UIColor = UIColor.black) {
        let defaultAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }
    
    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 11), color: UIColor = UIColor.white) {
        let selectedAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): font,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
        if #available(iOS 13.0, *) {
            selectedSegmentTintColor = UIColor.themeColor
        } else {
            // Fallback on earlier versions
            tintColor = UIColor.themeColor
        }
    }
}

extension UITextField {
    func findLocaleByCurrencyCode(_ currencyCode: String) -> Locale? {
        let locales = Locale.availableIdentifiers
        var locale: Locale?
        for   localeId in locales {
            locale = Locale(identifier: localeId)
            if let code = (locale! as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String {
                if code == currencyCode {
                    return locale
                }
            }
        }
        return locale
    }
    
}
extension Notification.Name {
    static let tabBarSwitchNotifications = Notification.Name("TabBarSwitchNotification")
    static let menuItemsSwitchNotifications = Notification.Name("MenuItemsSwitchNotification")
    static let leftMenuNotifications = Notification.Name("LeftMenuNotification")
    static let refreshList = Notification.Name("RefreshList")
    static let logoutNotification  = Notification.Name("LOGOUT")
    static let remoteNotification  = Notification.Name("REMOTE_NOTIFICATION")
    static let eServicesNotification = Notification.Name("ESERVICES_NOTIFICATION")
    static let homeViewControllerPopup = Notification.Name("HOME_POPUP")
    static let appTimeout = Notification.Name("AppTimout")
    static let sessionExpire = Notification.Name("SESSION_EXPIRE")
    static let openURL = Notification.Name("openURL")
    static let checkBiometricStatus = Notification.Name("checkBiometricStatus")
    
}
extension Sequence where Iterator.Element: Equatable {
    func unique() -> [Iterator.Element] {
        return reduce([], { collection, element in collection.contains(element) ? collection : collection + [element] })
    }
    func uniqueList() -> [Iterator] {
        return reduce([], { collection, element in collection.contains(element) ? collection : collection + [element] }) as! [Self.Iterator]
    }
}

extension Array {
    
    func unique<T:Hashable>(by: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(by(value)) {
                set.insert(by(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
extension Collection where Element: Hashable {
    var orderedSet: [Element] {
        var set: Set<Element> = []
        return reduce(into: []){ set.insert($1).inserted ? $0.append($1) : ()  }
    }
}
extension NSManagedObject {
    class func create(in context: NSManagedObjectContext) -> Self {
        let classname = entityName()
        let object = NSEntityDescription.insertNewObject(forEntityName: classname, into: context)
        return unsafeDowncast(object, to: self)
    }

    // Returns the unqualified class name, i.e. the last component.
    // Can be overridden in a subclass.
    class func entityName() -> String {
        return String(describing: self)
    }
}

extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }

    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)

        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)

        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)

        default:
            return viewController
        }
    }
}
extension UIDevice {
    static let modelName: String = {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }

            func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
                #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return "iPod touch (5th generation)"
                case "iPod7,1":                                 return "iPod touch (6th generation)"
                case "iPod9,1":                                 return "iPod touch (7th generation)"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPhone12,8":                              return "iPhone SE (2nd generation)"
                case "iPhone13,1":                              return "iPhone 12 mini"
                case "iPhone13,2":                              return "iPhone 12"
                case "iPhone13,3":                              return "iPhone 12 Pro"
                case "iPhone13,4":                              return "iPhone 12 Pro Max"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
                case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
                case "iPad11,6", "iPad11,7":                    return "iPad (8th generation)"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad11,3", "iPad11,4":                    return "iPad Air (3rd generation)"
                case "iPad13,1", "iPad13,2":                    return "iPad Air (4th generation)"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
                case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
                case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "AudioAccessory5,1":                       return "HomePod mini"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
                }
                #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
                #endif
            }

            return mapToDevice(identifier: identifier)
        }()
}

extension UIView {
//   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
    
    func roundTopCorners() {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 30, height: 30))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}

extension UIView {
    
    func removeShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 0.50).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowRadius = 1.0
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
   
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 0.50).cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}


extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

extension UIView{
    func blink(enabled: Bool = true, duration: CFTimeInterval = 1.0, stopAfter: CFTimeInterval = 0.0 ) {
        enabled ? (UIView.animate(withDuration: duration, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 0.0 },
            completion: { [weak self] _ in self?.alpha = 1.0 })) : self.layer.removeAllAnimations()
        if !stopAfter.isEqual(to: 0.0) && enabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + stopAfter) { [weak self] in
                self?.layer.removeAllAnimations()
            }
        }
    }
}


extension UIView {
    func setBottomBorder() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func createSpinnerFooter()->UIView{
        let footerView = UIView(frame: CGRect(x:0, y:0,width: self.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}
