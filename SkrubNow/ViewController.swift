//
//  ViewController.swift
//  asdfsdf
//
//  Created by Harsh on 10/21/16.
//  Copyright © 2016 Harsh. All rights reserved.
//

import UIKit
import MapKit
//import Firebase
import Stripe


class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var searchBAr: UISearchBar!
    let kBaseURL = "http://lowcost-env.rrpikpmqwu.us-east-1.elasticbeanstalk.com/charge";
    let locationManager = CLLocationManager()
    var hasFoundLocation = false
    var mapIsLoaded = false
    var valueForMap = NSMutableArray()
    var numberOfResults = Int()
    let firebaseSecureData = FirebaseData.init()
    var successfulTransactionApproved = false
    var matchingItems:[MKMapItem] = []
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var requestWashButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        //searchBar
        searchBAr.delegate = self
        //mapkit
        self.mapKitView.delegate = self
        self.mapKitView.showsUserLocation = true
        self.mapKitView.layer.cornerRadius = 10.0
        self.requestWashButton.layer.cornerRadius = 10.0
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseSecureData.loadClientData()
    }
    

    
    @IBAction func requestButtonPressed(_ sender: AnyObject) {
        let requestVC = acuityWebPageViewController.init(nibName:"acuityWebPageViewController", bundle: nil)
        requestVC.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.addChildViewController(requestVC)
        self.view.addSubview(requestVC.view)
        
    }
    
    //Delegate methods for Mapkid
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        self.mapIsLoaded = true
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if(!self.hasFoundLocation){
            let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250)
            self.mapKitView.setRegion(self.mapKitView.regionThatFits(region), animated: true)
            self.mapKitView.mapType = .satellite
            let point = MKPointAnnotation()
            point.coordinate = userLocation.coordinate
            point.title = "Location"
            point.subtitle = "My Current Location"
            //        self.mapKitView.addAnnotation(point)
            hasFoundLocation = true
        }
    }
    
    //searchbar delegate methods
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBar.text
        request.region = mapKitView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
         
            self.mapKitView.centerCoordinate = pointAnnotation.coordinate
            
            self.matchingItems = response.mapItems
            NSLog("fffS")
        }
        searchBar.resignFirstResponder()
        /*
        
        //2
        let localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            self.matchingItems = (localSearchResponse?.mapItems)!
            self.numberOfResults = (localSearchResponse?.mapItems.count)!
            //3
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.title = searchBar.text
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            //let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
            self.mapKitView.centerCoordinate = pointAnnotation.coordinate
           // self.mapKitView.addAnnotation(pinAnnotationView.annotation!)
        }
       //  NSLog("blahh %@", self.matchingItems.count)
        
 */
        
    }
    
    
    
    //Error handling
    
    func handleError(error: NSError) {
        UIAlertController(title: "Hmmm there seems to be an error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert).show(self, sender: self)
        
        
    }
}

