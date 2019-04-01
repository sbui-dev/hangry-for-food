//
//  RestaurantData.swift
//  hangry
//
//  Created by Steven Bui on 3/31/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import Foundation
import MapKit

class RestaurantData {
    var name : String = ""
    var address1 : String = ""
    var address2 : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    init() {
    
    }
    
    func getMapCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
