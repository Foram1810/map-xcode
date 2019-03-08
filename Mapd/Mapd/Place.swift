//
//  Place.swift
//  Mapd
//
//  Created by newuser on 2019-03-07.
//  Copyright © 2019 newuser. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    @objc init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
