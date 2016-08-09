//
//  Toko.swift
//  MapSearchDemo
//
//  Created by PT. Wavin Tunas Utama on 8/4/16.
//  Copyright © 2016 PT. Wavin Tunas Utama. All rights reserved.
//

import Foundation
import MapKit

class Toko: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let cityName: String
    let provinsiName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, cityName: String, provinsiName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.cityName = cityName
        self.provinsiName = provinsiName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}