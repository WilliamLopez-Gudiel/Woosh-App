//
//  ViewController.swift
//  workoutApp
//
//  Created by William Gudiel on 8/12/20.
//  Copyright © 2020 William. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class HomeController: UIViewController {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    

    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
   
    
    var WeatherManager = weatherManager()
    let locationManager = CLLocationManager()
        
    
    
    @IBAction func startRunPressed(_ sender: UIButton) {
        
        
    }
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        navigationItem.hidesBackButton = true
            
            searchTextField.delegate = self
            WeatherManager.delegate = self
        }
    
    @IBAction func logPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLogging", sender: self)
    }
    
}







//MARK: - UITextFieldDelegate

extension HomeController: UITextFieldDelegate {
    @IBAction func searchedPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            searchTextField.text = ""
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if(textField.text != ""){
                return true
            }
            else{
                textField.placeholder = "Type Something!"
                return false
            }
        }
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            //use searchFieldText.text to get the weather
            if let city = searchTextField.text {
                WeatherManager.fetchWeather(cityName:city)
            }
            searchTextField.text = ""
        }
    }
    //MARK: - WeatherManager Delegate

    extension HomeController: WeatherManagerDelegate{
        func didUpdateWeather(_ weatherManager: weatherManager , weather: WeatherModel) {
            DispatchQueue.main.async {
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
            }
            
        }
        
        func didFailWithError(error: Error) {
            print(error)
        
        }
    }

    //MARK: - CLLocationManagerDelegate
    extension HomeController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                
                WeatherManager.fetchWeather(latitude: lat,longitude: lon)
            }
            
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }


}

