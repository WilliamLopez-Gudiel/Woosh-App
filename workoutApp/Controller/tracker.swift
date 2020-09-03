//
//  tracker.swift
//  workoutApp
//
//  Created by William Gudiel on 8/13/20.
//  Copyright © 2020 William. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation


class trackerController: UIViewController {
    
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var theDate:String!
    var meters = 0.0
    var (hr, min, sec) = (0.0,0.0,0.0)
    var totalSec = 0.0
    var delay = 0
    
    let db = Firestore.firestore()
 
    
    
    
    var timer = Timer()
    var clock = 0.0
    
    override func viewDidLoad() {
              super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
            locationManager.distanceFilter = 1
            theMap.showsUserLocation = true
            theMap.userTrackingMode = .follow
            
        }
              // Do any additional setup after loading the view.
          }
    
    
    
    
    
    @IBAction func startBtn(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        sender.alpha = 0
        theDate = Date().localizedDescription(dateStyle: .short, timeStyle: .short)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLabel), userInfo: nil, repeats: true)
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Double) -> (Double, Double, Double) {
      let (hr,  minf) = modf (seconds / 3600)
      let (min, secf) = modf (60 * minf)
      return (hr, min, 60 * secf)
    }
    
    
    @objc func updateLabel(){
        clock += 0.1
        totalSec += 0.1
        (hr, min, sec) = secondsToHoursMinutesSeconds(seconds: clock)
        self.timerLabel.text = "\(Int(hr)):\(Int(min)):\(Int(sec))"
    }
    
    @IBAction func endBtn(_ sender: UIButton) {
        startBtn.alpha = 1.0
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
        let m = meters / 1609.344
        let hours = totalSec / 3600
        let averageSpeed = m / hours

        
        db.collection("log").addDocument(data: [
            "TimeHR": String(Int(hr)),
            "TimeMin": String(Int(min)),
            "TimeSec": String(Int(sec)),
            "Distance": milesLabel.text!,
            "averageSpeed": String(format: "%.2f", averageSpeed),
            "Date": Date().localizedDescription(dateStyle: .short, timeStyle: .short),
            "sort": Date().timeIntervalSince1970
        ]) { error in
            if let e = error {
                print("There was an issue with saving data, \(e)")
            } else{
                print("saved data")
            }
        }
        
        reset()
        performSegue(withIdentifier: "segueToResult", sender: self)
    }
    
    
    func reset(){
        timerLabel.text = "0:0:0"
        milesLabel.text = "0.00"
        speedLabel.text = "0"
        meters = 0.0
        (hr, min, sec) = (0.0,0.0,0.0)
        totalSec = 0.0
        delay = 0
        
        
    }
    

}


//MARK: - CLLocationManagerDelegate

extension trackerController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if delay < 3 {
            delay += 1
        }
        else {
        if startLocation == nil {
            startLocation = locations.first
        } else if let location = locations.last {
            meters += lastLocation.distance(from: location)
            let m = meters / 1609.344
            milesLabel.text = String(format: "%0.2f", m)
        }
        lastLocation = locations.last
        speedLabel.text = String(format: "%.2f", lastLocation.speed * 2.236936)
        
    }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
}


//MARK: - DateFormatter
extension Formatter {
    static let date = DateFormatter()
}

extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                           in timeZone : TimeZone = .current,
                              locale   : Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
}
