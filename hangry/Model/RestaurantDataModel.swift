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
    var url : String = ""
    
    private var street: String = ""
    private var city: String = ""
    private var state: String = ""
    private var postalCode: String = ""
    private var country: String = ""

    private var latitude : Double = 0.0
    private var longitude : Double = 0.0
    
    private var error : Bool = false
    private var lastRand : Int = -1
    
    init(json : JSON) {
        dataJSON = json
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func randomRestaurantData() {

        if var totalResult = dataJSON["total"].int {
            
            if totalResult == 0 {
                name = "No results found"
                address1 = "Perhaps everything is closed"
                address2 = "Try changing search options"
                error = true
                return
            }
            
            var rand = -1
            
            if totalResult != 1 {
                // offset by 1
                totalResult -= 1
                
                // randomly select an entry that isn't the last entry shown
                repeat {
                    rand = Int.random(in: 0 ... totalResult)
                } while lastRand == rand
                
                lastRand = rand
                
                // catch case with nil data
                while dataJSON["businesses"][rand]["name"].string == nil {
                    rand = Int.random(in: 0 ... totalResult)
                }
                //print("last random number = \(lastRand)")
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
            url = dataJSON["businesses"][rand]["url"].string!
            //print(name)
            //print(address1)
            //print(address2)
            
            // simulated data for screenshots
//            name = "Best Restaurant Ever"
//            address1 = "123 Main st"
//            address2 = dataJSON["businesses"][rand]["location"]["display_address"][1].string!
//            phone = "(555) 555-5555"
        }
        else {
            name = "Error: No results found"
            address1 = "Couldn't determine location"
            address2 = "Please allow in privacy settings"
            error = true
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
