//
//  ViewController.swift
//  hangry
//
//  Created by Steven Bui on 3/29/19.
//  Copyright © 2019 Steven Bui. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class MapViewController: UIViewController {
    
    var restaurantData : RestaurantData?

    @IBOutlet weak var restaurant_name: UILabel!
    @IBOutlet weak var restaurant_address1: UILabel!
    @IBOutlet weak var restaurant_address2: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
    }

    @IBAction func hangryPressed(_ sender: Any) {
        restaurantData!.randomRestaurantData()
        updateUI()
    }
    
    @IBAction func mapsPressed(_ sender: Any) {
        openMaps(coordinate: restaurantData!.getMapCoordinate())
    }
    
    //MARK: Populate UI
    /***************************************************************/
    
    func updateUI() {
        
        // update labels
        restaurant_name.text = restaurantData!.name
        restaurant_name.adjustsFontSizeToFitWidth = true
        
        restaurant_address1.text = restaurantData!.address1
        restaurant_address1.adjustsFontSizeToFitWidth = true
        
        restaurant_address2.text = restaurantData!.address2
        restaurant_address2.adjustsFontSizeToFitWidth = true
        
        // update map
        let coordinateRegion = MKCoordinateRegion(center: (restaurantData!.getMapCoordinate()),
                                                  latitudinalMeters: 1500, longitudinalMeters: 1500)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.title = restaurantData?.name
        annotation.coordinate = (restaurantData!.getMapCoordinate())
        
        mapView.addAnnotation(annotation)
    }
}

extension MapViewController : MKMapViewDelegate {
    
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
        let placemark = MKPlacemark(coordinate: coordinate, postalAddress: restaurantData!.getPostalAddress())
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: launchOptions)
    }
}