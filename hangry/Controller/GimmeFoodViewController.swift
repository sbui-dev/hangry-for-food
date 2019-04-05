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
    var restaurantData : RestaurantData?
    
    let locationManager = CLLocationManager()
    var searchOptions = SearchOptionsData()
 
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var hangryButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // create a rounded border for options button
        optionsButton.layer.cornerRadius = optionsButton.frame.height/2.0
        optionsButton.layer.masksToBounds = true
        optionsButton.layer.borderWidth = 1
        optionsButton.layer.borderColor = #colorLiteral(red: 0.7529411765, green: 0.09019607843, blue: 0.1137254902, alpha: 1)
        
        // disable button until GPS location
        hangryButton.isEnabled = false
    }
    
    @IBAction func hangryPressed(_ sender: Any) {
        performSegue(withIdentifier: "goToMapView", sender: nil)
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
        
        //print("Running with params")
        //print(searchParams)
        if dataJSON.isEmpty {
            //print("using yelp api")
            Alamofire.request(yelpURL, method : .get, parameters : searchParams, headers : header).responseJSON {
                response in
                if response.result.isSuccess {
                    self.dataJSON = JSON(response.result.value!)
                    self.restaurantData = RestaurantData(json : self.dataJSON)
                    //print(self.dataJSON)
                    self.hangryButton.isEnabled = true
                } else {
                    //print("Error: \(String(describing: response.result.error))")
                    self.restaurantData?.name = "Error: Unable to connect to server"
                }
            }
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
            
            getRestaurantData() // TODO bug - makes multiple calls when transitioning from other pages
            //print("found location")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.restaurantData?.name = "Error: Could not detect location"
    }
}
