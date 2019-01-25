//
//  CreditCardViewController.swift
//  asdfsdf
//
//  Created by Harsh on 10/21/16.
//  Copyright © 2016 Harsh. All rights reserved.
//

import UIKit

class CreditCardViewController: UIViewController {

    @IBOutlet weak var expirationYear: UITextField!
    @IBOutlet weak var nameOnCard: UITextField!
    @IBOutlet weak var cvcCode: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var paymentInputInfo: STPPaymentCardTextField!
    @IBOutlet weak var mainView: UIView!
    let kBaseURL = "http://localhost:3000/charge";
    override func viewDidLoad() {
        super.viewDidLoad()
                self.doneButton.layer.cornerRadius = 15.0
        self.cancelButton.layer.cornerRadius = 15.0
        self.mainView.layer.cornerRadius = 15.0
        
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
    }

    @IBAction func creditCardSubmitTapped(_ sender: AnyObject) {
//        let stripCard = STPCardParams()
//        
//        // Send the card info to Strip to get the token
//        stripCard.number = self.creditCardNumber.text
//        stripCard.cvc = self.cvcCode.text
//        stripCard.expMonth = UInt(self.expirationDate.text!)!
//        stripCard.expYear = UInt(self.expirationYear.text!)!
        
        FirebaseData.CardData.ccNumber = self.creditCardNumber.text!
        FirebaseData.CardData.cvcCode = self.cvcCode.text!
        FirebaseData.CardData.expMonth = UInt(self.expirationDate.text!)!
        FirebaseData.CardData.expYear = UInt(self.expirationYear.text!)!
        self.view.removeFromSuperview()
        
//        STPAPIClient.shared().createToken(withCard: stripCard, completion: {(token, error) -> Void in
//            if error != nil {
//                //                self.handleError(error: error! as NSError)
//                NSLog("NOOOOO*")
//                return
//            }
//            self.postStripeToken(token: token!)
//        })
        
    }

    func postStripeToken(token: STPToken) {
        var request = URLRequest(url: URL(string: kBaseURL)!)
        request.httpMethod = "POST"
        let postString = "amount=2500&stripeToken=" + token.tokenId
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
            _ = try! JSONSerialization.jsonObject(with: data, options: [])
//            print(json)
        }
        task.resume()
    
}
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.view.removeFromSuperview()
    }
    @IBAction func mainViewTap(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
 
}

