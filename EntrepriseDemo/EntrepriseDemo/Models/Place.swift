//
//  Place.swift
//  EntrepriseDemo
//
//  Created by Nestor Hernandez on 9/5/18.
//  Copyright © 2018 Néstor Hernández Bautista. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    var title:String?
    var subtitle: String?
    var coordinate : CLLocationCoordinate2D
    var identifier = "Place"
    init(_ title:String?, _ subtitle:String?, _ coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
