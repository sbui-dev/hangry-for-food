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
    
    let AK = "5Q2kfy87piLkOggEBScFBbEuQYe1xB8p0fGvOZJvMGPNpr5UppfZQL3HbAEFbzFpBEGi3F_TGhlH1pheY_kMZIw0NM0cckMB62l-fOv7onO5MsAMLrhrA5dXIWKgXHYx"
    
    var latitude = ""
    var longitude = ""
    
    
    @IBOutlet weak var foodSearch: UISearchBar!
    
    //Instance variables
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.requestLocation()
    }

    @IBAction func hangryPressed(_ sender: Any) {
        getRestaurantData()
    }

    // MARK: - Networking
    /***************************************************************/
    
    func getRestaurantData() {
        let yelpURL = "https://api.yelp.com/v3/businesses/search"
        let header : [String : String] = ["Authorization" : "Bearer "]
        
        let searchParams = ["term" : "restaurant", "latitude" : latitude, "longitude" : longitude, "radius" : "500", "open_now" : "false"]
        
        print("Running with params")
        print(searchParams)
        Alamofire.request(yelpURL, method : .get, parameters : searchParams, headers : header).responseJSON {
            response in
            if response.result.isSuccess {
                let dataJSON : JSON = JSON(response.result.value!)
                print(dataJSON)
                
            } else {
                print("Error: \(String(describing: response.result.error))")
            
            }
        }
    }
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.startUpdatingLocation()
            locationManager.delegate = nil
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

