//
//  logging.swift
//  workoutApp
//
//  Created by William Gudiel on 8/24/20.
//  Copyright © 2020 William. All rights reserved.
//

import UIKit
import Firebase


class logging: UITableViewController {
    

    
    var logs:[Logs] = []
    
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        
        tableView.register(UINib(nibName: "logCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection("log").order(by: "sort", descending: true).getDocuments { (querySnapshot, error) in
            if let e = error {
                print("Error in retrieving log data, \(e)")
            } else {
                if let logDocuments = querySnapshot?.documents {
                    for log in logDocuments {
                        let data = log.data()
                        if let dates = data["Date"] as? String, let averages = data["averageSpeed"] as? String,
                        let distances = data["Distance"] as? String {
                            let times:String  = "\(data["TimeHR"]!)Hrs \(data["TimeMin"]!)Mins \(data["TimeSec"]!)s" as String
                            let aWorkout = Logs(date: dates, distance: distances, time: times, average: averages)
                            print(times)
                            self.logs.append(aWorkout)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let log = logs[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! logCell
        
        cell.averageLabel.text = log.average
        cell.dateLabel.text = log.date
        cell.distanceLabel.text = log.distance
        cell.timelabel.text = log.time
        return cell
        
    }
    
   
}



