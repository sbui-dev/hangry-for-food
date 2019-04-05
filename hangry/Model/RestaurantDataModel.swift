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
import SwiftyJSON

class RestaurantData {
    
    var dataJSON : JSON = []
    
    var name : String = ""
    var address1 : String = ""
    var address2 : String = ""
    var address3 : String = ""
    var phone : String = ""
    
    var street: String = ""
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var country: String = ""

    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    init(json : JSON) {
        dataJSON = json
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func randomRestaurantData() {
        print(dataJSON)
        if var totalResult = dataJSON["total"].int {
            
            if totalResult == 0 {
                name = "No results found"
                address1 = "Try changing options"
                return
            }
            
            var rand = 0
            
            if totalResult != 1 {
                // offset by 1
                totalResult -= 1
                
                // randomly select an entry
                rand = Int.random(in: 0 ... totalResult)
                
                // catch case with nil data
                while dataJSON["businesses"][rand]["name"].string == nil {
                    rand = Int.random(in: 0 ... totalResult)
                }
                
                //print("random number = \(rand)")
            }
            
            // get data from entry
            name = dataJSON["businesses"][rand]["name"].string!
            street = dataJSON["businesses"][rand]["location"]["address1"].string!
            city = dataJSON["businesses"][rand]["location"]["city"].string!
            state = dataJSON["businesses"][rand]["location"]["state"].string!
            postalCode = dataJSON["businesses"][rand]["location"]["zip_code"].string!
            country = dataJSON["businesses"][rand]["location"]["country"].string!
            address1 = dataJSON["businesses"][rand]["location"]["display_address"][0].string!
            address2 = dataJSON["businesses"][rand]["location"]["display_address"][1].string!
            if dataJSON["businesses"][rand]["location"]["display_address"].count > 2 {
                address3 = dataJSON["businesses"][rand]["location"]["display_address"][2].string!
            }
            else {
                address3 = ""
            }
            phone = dataJSON["businesses"][rand]["display_phone"].string!
            latitude = dataJSON["businesses"][rand]["coordinates"]["latitude"].double!
            longitude =  dataJSON["businesses"][rand]["coordinates"]["longitude"].double!
            
            //print(name)
            //print(address1)
            //print(address2)
        }
        else {
           name = "Error: No results found"
        }
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
