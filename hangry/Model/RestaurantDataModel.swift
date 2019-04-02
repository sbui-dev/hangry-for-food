//
//  RestaurantData.swift
//  hangry
//
//  Created by Steven Bui on 3/31/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class RestaurantData {
    var name : String = ""
    var address1 : String = ""
    var address2 : String = ""
    
    var street: String = ""
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var country: String = ""

    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    init() {
    
    }
    
    func getMapCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func getPostalAddress () -> CNPostalAddress {
        let address = CNMutablePostalAddress()
        address.street = street
        address.city = city
        address.state = state
        address.postalCode = postalCode
        address.country = country
        return address
    }
}
