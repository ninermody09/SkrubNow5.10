//
//  ScheduleViewController.swift
//  asdfsdf
//
//  Created by Harsh on 10/21/16.
//  Copyright © 2016 Harsh. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    let fireBaseSecureData = FirebaseData()
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    var pickerData: NSMutableArray =  []
    @IBOutlet weak var viewWithContent: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerData = FirebaseData.ScheduleData.availableTimes
        if(self.pickerData.count > 0){
            pickerView.dataSource = self
            pickerView.delegate = self
        }
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(blurEffectView)
        self.viewWithContent.layer.cornerRadius = 15.0
        self.view.bringSubview(toFront: self.viewWithContent)
        self.cancelButton.layer.cornerRadius = 15.0
        self.doneButton.layer.cornerRadius = 15.0

        // Do any additional setup after loading the view.
    }

    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

   // func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //    return pickerData[row]
  //  }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as? String
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        self.view.removeFromSuperview()
    }
    

}
