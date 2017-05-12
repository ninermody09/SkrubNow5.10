//
//  RequestedWashViewController.swift
//  asdfsdf
//
//  Created by Harsh on 10/21/16.
//  Copyright © 2016 Harsh. All rights reserved.
//

import UIKit

class RequestedWashViewController: UIViewController {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton.layer.cornerRadius = 15.0
        self.mainView.layer.cornerRadius = 15.0
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
        // Do any additional setup after loading the view.
    }

    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        self.view.removeFromSuperview()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
