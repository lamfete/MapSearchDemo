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
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}