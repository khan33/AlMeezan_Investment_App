//
//  GeocodeService.swift
//  AlMeezan
//
//  Created by Atta khan on 30/08/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import CoreLocation

typealias Placemark = CLPlacemark

protocol GeocodeServiceDelegate: class {
    func didLoadPlacemark(_ placemark: Placemark)
}

class GeocodeService {
    weak var delegate: GeocodeServiceDelegate?
    private let geocoder = CLGeocoder()
    
    func reverseGeocode(_ location: CLLocation) {
        let context = (delegate)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?[0] else {
                return
            }
            
            context?.didLoadPlacemark(placemark)
        }
    }
}
