//
//  FirebaseData.swift
//  asdfsdf
//
//  Created by Harsh on 2/20/17.
//  Copyright © 2017 Harsh. All rights reserved.
//

import Foundation
import Firebase
//
//let foo = FirebaseData()

//var bar: FirebaseData = {
//    let b = FirebaseData()
//    return b
//}()

class FirebaseData: NSObject {
    
    var valueForMap = NSMutableArray()
    var filtedTimes = NSMutableArray()
    var hasAvailableTimeReturned: Bool = false
    static let singleton = FirebaseData()
    
    
    func loadClientData() {
        let ref = FIRDatabase.database().reference(withPath: "ScheduleAvailability")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.valueForMap = snapshot.value as! NSMutableArray
            self.addTimesToFiltered()
        }) { (error) in
            print(error.localizedDescription)
            return
        }
    }

    func addTimesToFiltered() {
        for time in self.valueForMap {
            if((time as? String) != nil){
                self.filtedTimes.add(time)
            }
        }
        ScheduleData.availableTimes = self.filtedTimes
        ScheduleData.hasAvailableTimeReturned = true

    }
    func hasAvailableTimes() -> Bool {
        if self.hasAvailableTimeReturned && self.filtedTimes.count > 0{
            return true
        }
        return false
    }
    func getFilteredTimeList() -> NSMutableArray {
        return self.filtedTimes
    }
    
    struct ScheduleData {
        static var availableTimes = NSMutableArray()
        static var hasAvailableTimeReturned : Bool = false
    }
    struct CardData {
        static var ccNumber = String()
        static var expMonth = UInt()
        static var expYear = UInt()
        static var nameOnCard = String()
        static var cvcCode = String()
    }
    
    struct UserData {
        static var clientName = String()
        static var phoneNumber = String()
        static var carMake = String()
        static var carModel = String()
        static var carYear = String()
        static var carColor = String()
        static var carTag = String()
        static var carInfo = String()
    }

}
