//
//  weatherMan.swift
//  workoutApp
//
//  Created by William Gudiel on 8/13/20.
//  Copyright © 2020 William. All rights reserved.
//

import Foundation
import CoreLocation
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: weatherManager , weather: WeatherModel)
    
    func didFailWithError(error: Error)
}
struct weatherManager {
    
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1bca0d5b21a51004d221d3a6a0322671&units=imperial"
    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        peformRequest(with: urlString)
    }
    
    func fetchWeather(latitude : CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        peformRequest(with: urlString)
    }
    
    func peformRequest(with urlString:String) {
        //create a url
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if(error != nil){
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.passJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
        //create a URLSession
        
        //Give the session a task
        
        //Start the task
    }
    
    func passJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
