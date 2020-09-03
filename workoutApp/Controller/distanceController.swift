//
//  distanceController.swift
//  workoutApp
//
//  Created by William Gudiel on 8/13/20.
//  Copyright © 2020 William. All rights reserved.
//


import UIKit
import  MapKit
import CoreLocation
import Firebase

class distanceController : UIViewController {
    
    @IBOutlet weak var milesLabel: UILabel!
    
    @IBOutlet weak var milesLabelContraint: NSLayoutConstraint!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var timeLabelContraint: NSLayoutConstraint!
    
    @IBOutlet weak var avgPaceLabel: UILabel!

    @IBOutlet weak var avgPaceLabelY: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!

    
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateResults();
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        milesLabelContraint.constant -= view.bounds.width
        timeLabelContraint.constant -= view.bounds.width
        avgPaceLabelY.constant -= view.bounds.width
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.0, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.milesLabelContraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.6, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.timeLabelContraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: 1.0, delay: 0.9, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.avgPaceLabelY.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func updateResults(){
        db.collection("log").order(by: "sort", descending: true).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Couldn't retrieve data from Firestore \(e)")
            } else{
                if let snapshotDocuments = querySnapshot?.documents {
                    let data = snapshotDocuments[0].data()
                    self.milesLabel.text = data["Distance"] as? String
                    self.timeLabel.text = "\(data["TimeHR"]!)Hrs \(data["TimeMin"]!)Mins \(data["TimeSec"]!)s" as String
                    self.avgPaceLabel.text = data["averageSpeed"] as? String
                    
                }
            }
        }
        
        
        
        
    }
    @IBAction func finishButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
