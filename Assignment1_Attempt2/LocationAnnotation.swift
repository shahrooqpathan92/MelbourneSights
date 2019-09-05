//
//  LocationAnnotation.swift
//  Assignment1_Attempt2
//
//  Created by Shahrooq Pathan on 5/9/19.
//  Copyright © 2019 Shahrooq Pathan. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double){
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    

}
