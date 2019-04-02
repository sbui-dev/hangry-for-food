//
//  GimmeFoodViewController.swift
//  hangry
//
//  Created by Steven Bui on 4/1/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class GimmeFoodViewController: UIViewController, CLLocationManagerDelegate {
    
    var dataJSON : JSON = []
    var currentLatitude : String = ""
    var currentLongitude : String = ""
    
    let locationManager = CLLocationManager()
    let restaurantData = RestaurantData()
    let searchOptions = SearchOptionsData()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MapViewController {
            let vc = segue.destination as? MapViewController
            vc?.restaurantData = restaurantData
        }
    }
    
    // MARK: - Networking
    /***************************************************************/
    
    func getRestaurantData() {
        let yelpURL = "https://api.yelp.com/v3/businesses/search"
        let header : [String : String] = ["Authorization" : "Bearer "]
        let searchParams = ["term" : searchOptions.term, "latitude" : currentLatitude, "longitude" : currentLongitude, "radius" : searchOptions.radius, "open_now" : searchOptions.open_now]
        
        print("Running with params")
        print(searchParams)
        if dataJSON.isEmpty {
            print("using yelp api")
            Alamofire.request(yelpURL, method : .get, parameters : searchParams, headers : header).responseJSON {
                response in
                if response.result.isSuccess {
                    self.dataJSON = JSON(response.result.value!)
                    self.parseJSON(json : self.dataJSON)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
            }
        }
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func parseJSON(json : JSON) {
        print(dataJSON)
        if var totalResult = json["total"].int {
            if totalResult == 0 {
                return
            }
            // TODO: fix for 0 and 1 result
            totalResult -= 1
            
            // randomly select an entry
            var rand = Int.random(in: 0 ... totalResult)
            
            // catch case with nil data
            while json["businesses"][rand]["name"].string == nil {
                rand = Int.random(in: 0 ... totalResult)
            }
            
            print("random number = \(rand)")
            
            // get data from entry
            restaurantData.name = json["businesses"][rand]["name"].string!
            restaurantData.street = json["businesses"][rand]["location"]["address1"].string!
            restaurantData.city = json["businesses"][rand]["location"]["city"].string!
            restaurantData.state = json["businesses"][rand]["location"]["state"].string!
            restaurantData.postalCode = json["businesses"][rand]["location"]["zip_code"].string!
            restaurantData.country = json["businesses"][rand]["location"]["country"].string!
            restaurantData.address1 = json["businesses"][rand]["location"]["display_address"][0].string!
            restaurantData.address2 = json["businesses"][rand]["location"]["display_address"][1].string!
            restaurantData.latitude = json["businesses"][rand]["coordinates"]["latitude"].double!
            restaurantData.longitude =  json["businesses"][rand]["coordinates"]["longitude"].double!
            
            print(restaurantData.name)
            print(restaurantData.address1)
            print(restaurantData.address2)
            
        }
        else {
            print("error no result")
        }
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.startUpdatingLocation()
            locationManager.delegate = nil
            
            currentLatitude = String(location.coordinate.latitude)
            currentLongitude = String(location.coordinate.longitude)
            
            getRestaurantData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //restaurant_name.text = "Error: Could not detect location"
    }
}
