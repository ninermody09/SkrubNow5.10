//
//  SearchResultsViewController.swift
//  SkrubNow
//
//  Created by Harsh Mody on 1/23/18.
//  Copyright © 2018 Harsh. All rights reserved.
//

import UIKit
import MapKit

class SearchResultsViewController: UIViewController, UITableViewDelegate {

    var addressList:[MKMapItem] = []
    @IBOutlet weak var searchTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTable.delegate = self
        self.searchTable.dataSource = self as? UITableViewDataSource
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20.0
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
    
        cell.textLabel?.text = "test"
        cell.detailTextLabel?.text = "123"
        return cell
    }

}
