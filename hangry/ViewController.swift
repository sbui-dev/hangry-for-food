//
//  ViewController.swift
//  hangry
//
//  Created by Steven Bui on 3/29/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var latitude : String = ""
    var longitude : String = ""
    var dataJSON : JSON = JSON()

    @IBOutlet weak var restaurant_name: UILabel!
    @IBOutlet weak var restaurant_address1: UILabel!
    @IBOutlet weak var restaurant_address2: UILabel!
    
    //Instance variables
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    @IBAction func hangryPressed(_ sender: Any) {
        getRestaurantData()
    }

    // MARK: - Networking
    /***************************************************************/
    
    func getRestaurantData() {
        let yelpURL = "https://api.yelp.com/v3/businesses/search"
        let header : [String : String] = ["Authorization" : "Bearer <token>"]
        
        let searchParams = ["term" : "restaurant", "latitude" : latitude, "longitude" : longitude, "radius" : "700", "open_now" : "false"]
        
        print("Running with params")
        print(searchParams)
        if dataJSON.isEmpty {
            print("using yelp api")
            Alamofire.request(yelpURL, method : .get, parameters : searchParams, headers : header).responseJSON {
                response in
                if response.result.isSuccess {
                    self.dataJSON = JSON(response.result.value!)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
            }
        }
        //print(self.dataJSON)
        self.parseJSON(json : self.dataJSON)
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func parseJSON(json : JSON) {
        
        if var totalResult = json["total"].int {
            // TODO: fix for 0 and 1 result
            totalResult -= 1
            
            let rand = Int.random(in: 0 ... totalResult)
            
            restaurant_name.text = json["businesses"][rand]["name"].string
            restaurant_name.adjustsFontSizeToFitWidth = true
            
            restaurant_address1.text = json["businesses"][rand]["location"]["display_address"][0].string
            restaurant_address1.adjustsFontSizeToFitWidth = true
            
            restaurant_address2.text = json["businesses"][rand]["location"]["display_address"][1].string
            restaurant_address2.adjustsFontSizeToFitWidth = true
            
            print(json["businesses"][rand]["name"].string)
            print(json["businesses"][rand]["location"]["display_address"].string)
            
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
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

