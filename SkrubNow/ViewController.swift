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


class ViewController: UIViewController, MKMapViewDelegate {
    
    let kBaseURL = "http://lowcost-env.rrpikpmqwu.us-east-1.elasticbeanstalk.com/charge";
    let locationManager = CLLocationManager()
    var hasFoundLocation = false
    var mapIsLoaded = false
    var valueForMap = NSMutableArray()
    let firebaseSecureData = FirebaseData.init()
    var successfulTransactionApproved = false
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var requestWashButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        firebaseSecureData.loadClientData()
        self.mapKitView.delegate = self
        self.mapKitView.showsUserLocation = true
        self.mapKitView.layer.cornerRadius = 10.0
        
        locationManager.requestWhenInUseAuthorization()
        self.requestWashButton.layer.cornerRadius = 10.0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        firebaseSecureData.loadClientData()
    }
    
    @IBAction func carInfoButtonPressed(_ sender: AnyObject) {
        let carInfoVC = CarInformationViewController.init(nibName:"CarInformationViewController", bundle: nil)
        carInfoVC.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.addChildViewController(carInfoVC)
        self.view.addSubview(carInfoVC.view)
    }
    @IBAction func scheduleButtonPressed(_ sender: AnyObject) {
        if(FirebaseData.ScheduleData.hasAvailableTimeReturned){
            
            let scheduleAppointmentVC = ScheduleViewController.init(nibName:"ScheduleViewController", bundle: nil)
            scheduleAppointmentVC.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.addChildViewController(scheduleAppointmentVC)
            self.view.addSubview(scheduleAppointmentVC.view)
        }
        
    }
    @IBAction func paymentButtonPressed(_ sender: AnyObject) {
        let paymentVC = CreditCardViewController.init(nibName:"CreditCardViewController", bundle: nil)
        paymentVC.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.addChildViewController(paymentVC)
        self.view.addSubview(paymentVC.view)
    }
    
    func postStripeToken(token: STPToken) {
        var request = URLRequest(url: URL(string: kBaseURL)!)
        request.httpMethod = "POST"
        let postString = "amount=500&stripeToken=" + token.tokenId
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            print(json)
            self.successfulTransactionApproved = true
        }
        task.resume()
        task.suspend()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        self.mapIsLoaded = true
    }
    
    @IBAction func requestButtonPressed(_ sender: AnyObject) {
        
        let stripCard = STPCardParams()
        
        // Send the card info to Strip to get the token
        stripCard.number = FirebaseData.CardData.ccNumber
        stripCard.cvc = FirebaseData.CardData.cvcCode
        stripCard.expMonth = FirebaseData.CardData.expMonth
        stripCard.expYear = FirebaseData.CardData.expYear
        stripCard.name = FirebaseData.CardData.nameOnCard
        
        STPAPIClient.shared().createToken(withCard: stripCard, completion: {(token, error) -> Void in
            
            if error != nil {
                self.handleError(error: error! as NSError)
                NSLog("Unsuccesful Transaction")
                return
            }
            self.postStripeToken(token: token!)
        })
        if(self.successfulTransactionApproved){
            let doneVC = RequestedWashViewController.init(nibName:"RequestedWashViewController", bundle: nil)
            doneVC.view.frame = CGRect(x:0, y:0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.addChildViewController(doneVC)
            self.view.addSubview(doneVC.view)
            FirebaseData.CardData.ccNumber = ""
            FirebaseData.CardData.cvcCode = ""
            self.successfulTransactionApproved = false
        }
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
    
    func handleError(error: NSError) {
        UIAlertController(title: "Hmmm there seems to be an error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert).show(self, sender: self)
        
        
    }
}

