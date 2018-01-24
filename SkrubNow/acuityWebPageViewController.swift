//
//  acuityWebPageViewController.swift
//  SkrubNow
//
//  Created by Harsh Mody on 1/22/18.
//  Copyright © 2018 Harsh. All rights reserved.
//

import UIKit

class acuityWebPageViewController: UIViewController {

    var address = ""
    var coordinates = ""
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.layer.cornerRadius = 10.0
        self.initScheduler()
    }

    func initScheduler() {
        let embeddedHTML = "<iframe src=\"https://app.acuityscheduling.com/schedule.php?owner=15026021&field:4277375=" + self.address + "\"width=\"100%\" height=\"800\" frameBorder=\"0\"></iframe><script src=\"https://d3gxy7nm8y4yjr.cloudfront.net/js/embed.js\" type=\"text/javascript\"></script>"
        
        self.webview.loadHTMLString(embeddedHTML, baseURL: nil)
        
    }


}
