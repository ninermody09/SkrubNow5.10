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
//import Stripe


class ViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var stackViewOptions: UIStackView!
    @IBOutlet var interiorOnlySwipe: UISwipeGestureRecognizer!
    @IBOutlet var exteriorOnlySwipe: UISwipeGestureRecognizer!
    @IBOutlet var fullServiceSwipe: UISwipeGestureRecognizer!
    
    @IBOutlet weak var fullServiceView: UIView!
    @IBOutlet weak var exteriorOnlyView: UIView!
    @IBOutlet weak var interiorOnlyView: UIView!
    
    var selectedViewName:String = ""
    
    @IBOutlet weak var heightOfTable: NSLayoutConstraint!
    
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var topLogo: UIImageView!
    @IBOutlet weak var searchBAr: UISearchBar!
    let kBaseURL = "http://lowcost-env.rrpikpmqwu.us-east-1.elasticbeanstalk.com/charge";
    let locationManager = CLLocationManager()
    var hasFoundLocation = false
    var mapIsLoaded = false
    var valueForMap = NSMutableArray()
    var numberOfResults = Int()
    //let firebaseSecureData = FirebaseData.init()
    var successfulTransactionApproved = false
    var matchingItems:[MKMapItem] = []
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var requestWashButton: UIButton!
    var finalAddress:NSString = ""
    var featuresArray:[String] = []
    
    @IBOutlet weak var infoLabel1: UILabel!
    @IBOutlet weak var inforView: UIView!
    
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var infoLabelPrice: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        
        self.view.bringSubview(toFront: self.topLogo)
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        keyboardToolbar.isTranslucent = true
        keyboardToolbar.barTintColor = UIColor.lightGray
        keyboardToolbar.alpha = 0.99
        let flexible = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(searchButtonHit))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(cancelButtonPressed))
        keyboardToolbar.items = [searchButton, flexible, cancelButton]
        
        searchBAr.inputAccessoryView = keyboardToolbar
        
//        self.inforView.isHidden = false
        self.infoViewHeight.constant = 0
        
        //searchBar
        searchBAr.delegate = self
        searchTableView.delegate = self
        searchTableView.dataSource = self as? UITableViewDataSource
        //        searchTableView.layer.cornerRadius = 10.0
        searchTableView.isHidden = true
        searchBAr.backgroundImage = UIImage()
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.searchBAr.frame
        rectShape.position = self.searchBAr.center
        rectShape.path = UIBezierPath(roundedRect: self.searchBAr.bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.searchBAr.layer.mask = rectShape
        
        let rectShape2 = CAShapeLayer()
        rectShape2.bounds = self.searchTableView.frame
        rectShape2.position = self.searchTableView.center
        rectShape2.path = UIBezierPath(roundedRect: self.searchTableView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.searchTableView.layer.mask = rectShape2
        
        let rectShape3 = CAShapeLayer()
        rectShape3.bounds = self.mapKitView.frame
        rectShape3.position = self.mapKitView.center
        rectShape3.path = UIBezierPath(roundedRect: self.mapKitView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        self.mapKitView.layer.mask = rectShape3
        
        let cancelButtonAttributes: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.black]
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        // searchTVC = SearchTableViewController.init(nibName: "SearchTableViewController", bundle: nil)
        //resultSearchController = UISearchController(searchResultsController: searchTVC)
        //  resultSearchController?.delegate = self as UISearchControllerDelegate
        // resultSearchController?.searchBar = self.searchBAr
        //self.present(resultSearchController!, animated: true, completion: nil)
        //mapkit
        self.mapKitView.delegate = self
        self.mapKitView.showsUserLocation = true
        //        self.mapKitView.layer.cornerRadius = 10.0
        //        self.requestWashButton.layer.cornerRadius = 10.0
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    func cancelButtonPressed() {
        self.resignFirstResponder()
        self.view.endEditing(true)
    }
    @IBAction func requestButtonPressed(_ sender: AnyObject) {
        let requestVC = acuityWebPageViewController.init(nibName:"acuityWebPageViewController", bundle: nil)
        if(self.finalAddress == ""){
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: self.mapKitView.centerCoordinate.latitude, longitude: self.mapKitView.centerCoordinate.longitude)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                if placeMark != nil {
                    let address1 = placeMark.name! as NSString
                    let zipCode = placeMark.postalCode! as NSString
                    let city = placeMark.locality! as NSString
                    self.finalAddress = NSString(format: "%@, %@ %@", address1, city, zipCode)
                    
                    requestVC.address = self.finalAddress as String
                    requestVC.typeOfService = self.selectedViewName as String
                    requestVC.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    self.addChildViewController(requestVC)
                    self.view.addSubview(requestVC.view)
                }
            })
        }else {
            requestVC.address = self.finalAddress as String
            
            requestVC.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.addChildViewController(requestVC)
            self.view.addSubview(requestVC.view)
        }
        
    }
    
    func searchButtonHit() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.searchBAr.text
        request.region = mapKitView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if(response.mapItems.count < 2){
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
                
                self.mapKitView.centerCoordinate = pointAnnotation.coordinate
                self.finalAddress = response.mapItems[0].placemark.title as! NSString
                
            } else {
                self.matchingItems = response.mapItems
                self.displayListOfResults(listOfAddresses:response.mapItems)
            }
        }
        self.view.endEditing(true)
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
            hasFoundLocation = true
            
        }
    }
    
    //searchbar delegate methods
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.searchTableView.isHidden = true
        searchBar.text = ""
        searchBar.placeholder = "Enter Address"
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.searchButtonHit()
        searchBar.resignFirstResponder()
    }
    //TABLE DELAGATES
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.searchTableView){
            return self.matchingItems.count
        }else if(tableView == self.infoTableView){
            return self.featuresArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(tableView == self.searchTableView){
            return 50.0
        }
        return 30.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if(tableView == self.searchTableView){
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            var address = ""
            address = self.matchingItems[indexPath.row].placemark.title!
            cell!.textLabel?.text = address
        }
        else if(tableView == self.infoTableView){
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            var feature = ""
            feature = self.featuresArray[indexPath.row] as! String
            cell!.textLabel?.text = feature
            cell!.textLabel?.textAlignment = .center
            cell!.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightUltraLight)
        }
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.searchTableView){
            let address = self.matchingItems[indexPath.row].placemark.title! as NSString
            self.finalAddress = address
            self.searchBAr.text = self.finalAddress as String
            setMapCoordinatePin(address: address as String)
            tableView.isHidden = true
        }
    }
    func displayListOfResults(listOfAddresses: [MKMapItem]) {
        if(listOfAddresses.count > 1) {
            self.heightOfTable.constant = getHeightOfTable(rows: listOfAddresses.count)
            self.searchTableView.reloadData()
            self.searchTableView.isHidden = false
        }
        
    }
    func getHeightOfTable(rows : Int) -> CGFloat {
        let totalHeight = rows * 44
        if(totalHeight > 469){
            return 220
        }
        return CGFloat(totalHeight)
        
    }
    func setMapCoordinatePin(address : String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = address
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
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: response.boundingRegion.center.latitude, longitude: response.boundingRegion.center.longitude)
            
            self.mapKitView.centerCoordinate = pointAnnotation.coordinate
        }
    }
    
    @IBAction func exteriorOnlySwipeUp(_ sender: Any) {
       
        self.featuresArray = [] //reset array
        self.featuresArray = ["Hand wash + Drying aid", "Microfiber cloth dry", "Wax application", "Wheels and tires", "Tire polish", "Exterior Windows"]
        self.infoLabel1.text = "Exterior Only"
        self.infoLabelPrice.text = "$35+"
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.reloadData()
        self.selectedViewName = "Ext"
        
        UIView.animate(withDuration: 0.5, animations: {
             self.inforView.isHidden = false
            self.infoViewHeight.constant = 140.0
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func interiorOnly(_ sender: Any) {
        self.interiorOnlyView.alpha = 0.95
        self.exteriorOnlyView.alpha = 0.95
        self.fullServiceView.alpha = 0.95
        
        
        self.featuresArray = []
        self.featuresArray = ["Vaccum Interior", "Dash Console, and Seat wipe", "Windows cleaned", "Door jams cleaned"]
        self.infoLabel1.text = "Interior Only"
        self.infoLabelPrice.text = "$22+"
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.reloadData()
        self.selectedViewName = "Int"
        UIView.animate(withDuration: 0.5, animations: {
            self.inforView.isHidden = false
            self.infoViewHeight.constant = 140.0
            self.view.layoutIfNeeded()
        })
    }
    //full service click

    @IBAction func tableSwipedUp(_ sender: Any) {
        self.interiorOnlyView.alpha = 0.95
        self.exteriorOnlyView.alpha = 0.95
        self.fullServiceView.alpha = 0.95
        
       
        self.featuresArray = []
        self.featuresArray = ["Vaccum Interior", "Dash Console, and Seat wipe", "Windows cleaned","Hand wash + Drying aid", "Microfiber cloth dry", "Wax application", "Wheels and tires", "Tire polish", "Exterior Windows"]
        self.infoLabel1.text = "Full Service"
        self.infoLabelPrice.text = "$50+"
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.reloadData()
        self.selectedViewName = "Full"
        UIView.animate(withDuration: 0.5, animations: {
             self.inforView.isHidden = false
            self.infoViewHeight.constant = 140.0
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func cancelServiceButtonHit(_ sender: Any) {
        self.interiorOnlyView.alpha = 0.95
        self.exteriorOnlyView.alpha = 0.95
        self.fullServiceView.alpha = 0.95
        
        UIView.animate(withDuration: 0.5, animations: {
            self.infoViewHeight.constant = 0
            self.view.layoutIfNeeded()
            self.inforView.isHidden = true
        }, completion: { (value: Bool) in
            self.inforView.isHidden = true})
        
    }
    
    @IBAction func serviceSelected(_ sender: Any) {
        switch self.selectedViewName {
        case "Int":
            self.interiorOnlyView.alpha = 1.0
            self.exteriorOnlyView.alpha = 0.80
            self.fullServiceView.alpha = 0.80
        case "Ext":
            self.interiorOnlyView.alpha = 0.80
            self.exteriorOnlyView.alpha = 1.0
            self.fullServiceView.alpha = 0.80
        case "Full":
            self.interiorOnlyView.alpha = 0.80
            self.exteriorOnlyView.alpha = 0.80
            self.fullServiceView.alpha = 1.0
        default:
            self.interiorOnlyView.alpha = 0.95
            self.exteriorOnlyView.alpha = 0.95
            self.fullServiceView.alpha = 0.95
        }

        UIView.animate(withDuration: 0.5, animations: {
            self.infoViewHeight.constant = 0
            self.view.layoutIfNeeded()
            self.inforView.isHidden = true
        }, completion: { (value: Bool) in
                self.inforView.isHidden = true})
    }
    
    
    //Error handling
    
    func handleError(error: NSError) {
        UIAlertController(title: "Hmmm there seems to be an error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert).show(self, sender: self)
    }
}



