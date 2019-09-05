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
    var icon: String?
    var image: String?
    
    init(newTitle: String, newSubtitle: String, lat: Double, long: Double, icon: String, image: String){
        self.title = newTitle
        self.subtitle = newSubtitle
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        self.icon = icon
        self.image = image
    }
    

}
