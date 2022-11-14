//
//  LocateUsVC.swift
//  AlMeezan
//
//  Created by Atta khan on 24/09/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SVProgressHUD

class LocateUsVC: UIViewController {

    @IBOutlet weak var bankBtn: UIButton!
    @IBOutlet weak var investmentBtn: UIButton!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var branchTxtField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var locateUsBtn: UIButton!
    @IBOutlet weak var investNowBtn: UIButton!
    
    @IBOutlet weak var branchAddressLbl: UILabel!
    @IBOutlet weak var addressView: UIView!
    var branch_locator_model    :   [BranchLocator]?
    var investement_branch      :   BranchLocator?
    var banck_branch            :   BranchLocator?
    var city_branches           :   [Branches]?
    var branchLocations =  CLLocation()
    
    
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        getBranchesData()
        let camera = GMSCameraPosition.camera(withLatitude:  30.3753, longitude: 69.3451, zoom: 5)
        mapView?.camera = camera
        DispatchQueue.main.async {
            self.mapView.animate(to: camera)
        }
    }
    
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
    func clearMap() {
        addressView.isHidden = true
        mapView.clear()
    }
    
    
    func mapSetUp(_ location: CLLocation) {
        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude:  location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 14)
        mapView?.camera = camera
        DispatchQueue.main.async {
            self.mapView.animate(to: camera)
        }
        let marker = GMSMarker(position: position)
        marker.map = mapView
    }
    
    func getBranchesData() {
        let bodyParam = RequestBody()
        let bodyRequest = bodyParam.encryptData(bodyParam)
        let url = URL(string: BRANCHLOCATOR)!
        SVProgressHUD.show()
        WebServiceManager.sharedInstance.fetch(params: bodyRequest as Dictionary<String, AnyObject>, url: url, serviceType: "Branch Locator", modelType: BranchLocator.self, errorMessage: { (errorMessage) in
            errorResponse = errorMessage
            self.showErrorMsg(errorMessage)
        }, success: { (response) in
            self.branch_locator_model   =   response
            if self.branch_locator_model?.count ?? 0 > 1 {
                self.investement_branch     =   self.branch_locator_model?[0]
                self.banck_branch           =   self.branch_locator_model?[1]
            }
        }, fail: { (error) in
            print(error.localizedDescription)
        }, showHUD: true)
    }
    
    
    func clearTxtfields() {
        cityTxtField.text = ""
        cityTxtField.placeholder = "Select City"
        branchTxtField.text = ""
        branchTxtField.placeholder = "Select Branch"
    }
    
    @IBAction func tapOnInvestmentBtn(_ sender: Any) {
        banck_branch = nil
        banck_branch    =   self.branch_locator_model?[0]
        investmentBtn.backgroundColor = UIColor.themeColor
        investmentBtn.setTitleColor(UIColor.white, for: .normal)
        bankBtn.setTitleColor(UIColor.black, for: .normal)
        bankBtn.backgroundColor = UIColor.white
        bankBtn.borderColor = UIColor.themeColor
        clearTxtfields()
        clearMap()
    }
    
    @IBAction func tapOnBankBtn(_ sender: Any) {
        banck_branch = nil
        banck_branch     =   self.branch_locator_model?[1]
        bankBtn.backgroundColor = UIColor.themeColor
        bankBtn.setTitleColor(UIColor.white, for: .normal)
        investmentBtn.setTitleColor(UIColor.black, for: .normal)
        investmentBtn.backgroundColor = UIColor.white
        investmentBtn.borderColor = UIColor.themeColor
        clearTxtfields()
        clearMap()
    }
    
    @IBAction func tapOnCityBtn(_ sender: Any) {
        let vc = SearchViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.data = banck_branch?.city
        vc.delegate = self
        vc.current_state = "City"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapOnBranchBtn(_ sender: Any) {
        let vc = SearchViewController.instantiateFromAppStroyboard(appStoryboard: .main)
        vc.city_branch_data = city_branches
        vc.current_state = "Branch"
        vc.branch_delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func navigateToMap(_ sender: Any) {
        let latitude    =   branchLocations.coordinate.latitude
        let longitude   =   branchLocations.coordinate.longitude
        let url         =   URL(string:
        "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
                NSLog("Can't use comgooglemaps://");
        }
    }
    
    @IBAction func callToSupport(_ sender: Any) {
        Utility.shared.phoneCall()
    }
    
    
}
extension LocateUsVC: CityProtocol, BranchProtocol {
    func getCities(_ city: String) {
        
    }
    
    func getBranches(_ branch: Branches?) {
        if let branch_name = branch?.branch {
            branchTxtField.text = branch_name
        }
        if let lat = branch?.lat, let long = branch?.long, let address = branch?.address {
            let location = CLLocation(latitude: lat, longitude: long)
            mapSetUp(location)
            branchLocations = location
            addressView.isHidden = false
            branchAddressLbl.text = address
        }
    }
    
    func getCityBranches(_ city: City?) {
        if let city_name = city?.city {
            cityTxtField.text = city_name
            branchTxtField.text = ""
            addressView.isHidden = true
        }
        if let lat = city?.cityLat, let long = city?.cityLong, lat != "", long != "" {
            let location = CLLocation(latitude: Double(lat)!, longitude: Double(long)!)
            mapSetUp(location)
        }
        city_branches = city?.branches
    }
    
    
}

