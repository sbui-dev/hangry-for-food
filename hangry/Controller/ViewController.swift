//
//  ViewController.swift
//  hangry
//
//  Created by Steven Bui on 3/29/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var currentLatitude : String = ""
    var currentLongitude : String = ""
    var dataJSON : JSON = []

    @IBOutlet weak var restaurant_name: UILabel!
    @IBOutlet weak var restaurant_address1: UILabel!
    @IBOutlet weak var restaurant_address2: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let restaurantData = RestaurantData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        let header : [String : String] = ["Authorization" : "Bearer "]
        
        let searchParams = ["term" : "restaurant", "latitude" : currentLatitude, "longitude" : currentLongitude, "radius" : "700", "open_now" : "false"]
        
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
            
            restaurantData.name = json["businesses"][rand]["name"].string!
            restaurantData.address1 = json["businesses"][rand]["location"]["display_address"][0].string!
            restaurantData.address2 = json["businesses"][rand]["location"]["display_address"][1].string!
            restaurantData.latitude = json["businesses"][rand]["coordinates"]["latitude"].double!
            restaurantData.longitude =  json["businesses"][rand]["coordinates"]["longitude"].double!
            
            print(restaurantData.name)
            print(restaurantData.address1)
            print(restaurantData.address2)
            
            updateUI()

        }
        else {
            print("error no result")
        }
    }
    
    //MARK: Populate UI
    /***************************************************************/
    
    func updateUI() {
        
        // update labels
        restaurant_name.text = restaurantData.name
        restaurant_name.adjustsFontSizeToFitWidth = true
        
        restaurant_address1.text = restaurantData.address1
        restaurant_address1.adjustsFontSizeToFitWidth = true
        
        restaurant_address2.text = restaurantData.address2
        restaurant_address2.adjustsFontSizeToFitWidth = true
        
        // update map
        let coordinateRegion = MKCoordinateRegion(center: restaurantData.getMapCoordinate(),
                                                  latitudinalMeters: 1500, longitudinalMeters: 1500)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = restaurantData.name
        annotation.coordinate = restaurantData.getMapCoordinate()
        mapView.addAnnotation(annotation)
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed")
        restaurant_name.text = "Error: Could not detect location"
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("annotation selected 1")
        if let location = view.annotation?.coordinate {
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
            
            let placemark = MKPlacemark(coordinate: location)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.openInMaps(launchOptions: launchOptions)
        }
        else {
            print("Error opening in map")
        }
    }
}
