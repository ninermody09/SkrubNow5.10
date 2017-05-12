//
//  CarInformationViewController.swift
//  asdfsdf
//
//  Created by Harsh on 10/21/16.
//  Copyright © 2016 Harsh. All rights reserved.
//

import UIKit

class CarInformationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mainFormView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var instructionsTF: UITextField!
    @IBOutlet weak var modelTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var colorTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var carMakeTF: UITextField!
    @IBOutlet weak var carTagTF: UITextField!
    @IBOutlet weak var clientNameTF: UITextField!
    @IBOutlet weak var widthOfScrollView: NSLayoutConstraint!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        widthOfScrollView.constant = self.view.frame.width - 30
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
        self.prefillData()
        
        self.carMakeTF.delegate = self
        self.instructionsTF.delegate = self
        self.modelTF.delegate = self
        self.phoneNumberTF.delegate = self
        self.colorTF.delegate = self
        self.yearTF.delegate = self
        self.clientNameTF.delegate = self
        self.carTagTF.delegate = self
        
        self.clientNameTF.tag = 0
        self.phoneNumberTF.tag = 1
        self.carMakeTF.tag = 2
        self.modelTF.tag = 3
        self.yearTF.tag = 4
        self.colorTF.tag = 5
        self.carTagTF.tag = 6
        self.instructionsTF.tag = 7
        self.clientNameTF.becomeFirstResponder()
        self.cancelButton.layer.cornerRadius = 15.0
        self.doneButton.layer.cornerRadius = 15.0
        
    }
    
    func addDataToGlobalVariables() {
        FirebaseData.UserData.clientName = self.clientNameTF.text!
        FirebaseData.UserData.phoneNumber = self.phoneNumberTF.text!
        FirebaseData.UserData.carMake = self.carMakeTF.text!
        FirebaseData.UserData.carModel = self.modelTF.text!
        FirebaseData.UserData.carYear = self.yearTF.text!
        FirebaseData.UserData.carColor = self.colorTF.text!
        FirebaseData.UserData.carTag = self.carTagTF.text!
        FirebaseData.UserData.carInfo = self.instructionsTF.text!
    }
    
    func saveDataToDevice() {
        let defaults = UserDefaults.standard
        let objDic = defaults.object(forKey: "UserData") as! NSDictionary!
        
        if((objDic?.count)! > 0){
            defaults.removeObject(forKey: "UserData")
        }
        let dict = ["Name": self.clientNameTF.text!, "PhoneNumber": self.phoneNumberTF.text!, "CarMake":self.carMakeTF.text!, "CarModel": self.modelTF.text!, "CarYear": self.yearTF.text!, "CarColor": self.colorTF.text!,"CarTag": self.carTagTF.text!, "CarInfo": self.instructionsTF.text!]
        defaults.set(dict, forKey: "UserData")
    }
    
    func prefillData() {
        let defaultData = UserDefaults.standard
        let objData = defaultData.object(forKey: "UserData") as! NSDictionary!
        if((objData?.count)! > 0){
            self.clientNameTF.text = objData?.object(forKey: "Name") as? String
            self.phoneNumberTF.text = objData?.object(forKey: "PhoneNumber") as? String
            self.carMakeTF.text = objData?.object(forKey: "CarMake") as? String
            self.modelTF.text = objData?.object(forKey: "CarModel") as? String
            self.yearTF.text = objData?.object(forKey: "CarYear") as? String
            self.colorTF.text = objData?.object(forKey: "CarColor") as? String
            self.carTagTF.text = objData?.object(forKey: "CarTag") as? String
            self.instructionsTF.text = objData?.object(forKey: "CarInfo") as? String
            self.addDataToGlobalVariables()
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        self.addDataToGlobalVariables()
        self.saveDataToDevice()
        self.view.removeFromSuperview()
    }
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {

        self.view.removeFromSuperview()
    }
    @IBAction func tapGestureHit(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let yPoint = textField.frame.origin.y - 5
        switch textField.tag
        {
        case 0:
            self.phoneNumberTF.becomeFirstResponder()
            break
        case 1:
            self.carMakeTF.becomeFirstResponder()
            self.mainFormView.setContentOffset(CGPoint(x: 0, y:yPoint), animated: true)
            break
        case 2:
            self.modelTF.becomeFirstResponder()
            self.mainFormView.setContentOffset(CGPoint(x: 0, y:yPoint), animated: true)
            break
        case 3:
            self.yearTF.becomeFirstResponder()
            self.mainFormView.setContentOffset(CGPoint(x: 0, y:yPoint), animated: true)
            break
        case 4:
            self.colorTF.becomeFirstResponder()
            self.mainFormView.setContentOffset(CGPoint(x: 0, y:yPoint), animated: true)
            break
        case 5:
            self.carTagTF.becomeFirstResponder()
            self.mainFormView.setContentOffset(CGPoint(x: 0, y:yPoint), animated: true)
            break
        case 6:
            self.instructionsTF.becomeFirstResponder()
            self.mainFormView.setContentOffset(CGPoint(x: 0, y:yPoint), animated: true)
            break
            
        default:
            textField.resignFirstResponder()
            self.mainFormView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        }
        return true

    }
    
}
