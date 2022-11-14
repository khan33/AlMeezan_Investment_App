//
//  LocationService.swift
//  AlMeezan
//
//  Created by Atta khan on 30/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import CoreLocation

typealias Location = CLLocation

protocol LocationServiceDelegate: class {
    func didUpdateLocation(_ location: Location)
    func didFailUpdatingLocation(_ message: String?)
}

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    weak var delegate: LocationServiceDelegate?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
    }
    
    func loadLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        let location = locations[0]
        
        delegate?.didUpdateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailUpdatingLocation("Could not find your location, you can enable it from settings")
    }
}
