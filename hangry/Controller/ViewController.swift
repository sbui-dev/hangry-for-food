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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
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
        
        mapView.delegate = self
        //getRestaurantData()
    }

    @IBAction func hangryPressed(_ sender: Any) {
        getRestaurantData()
        parseJSON(json : dataJSON)
        updateUI()
    }
    
    @IBAction func mapsPressed(_ sender: Any) {
        openMaps(coordinate: restaurantData.getMapCoordinate())
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
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func parseJSON(json : JSON) {
        print(dataJSON)
        if var totalResult = json["total"].int {
            // TODO: fix for 0 and 1 result
            totalResult -= 1
            
            // randomly select an entry
            let rand = Int.random(in: 0 ... totalResult)
            
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
        restaurant_name.text = "Error: Could not detect location"
    }
}

extension ViewController : MKMapViewDelegate {
    
    //MARK: MapView
    /***************************************************************/
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let location = view.annotation?.coordinate {
            openMaps(coordinate : location)
        }
        else {
            print("Error opening in map")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view : MKMarkerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y : 5)
        view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        
        return view
    }
    
    func openMaps(coordinate : CLLocationCoordinate2D) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let placemark = MKPlacemark(coordinate: coordinate, postalAddress: restaurantData.getPostalAddress())
        let mapItem = MKMapItem(placemark: placemark)
        //mapItem.name = restaurantData.name
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}
