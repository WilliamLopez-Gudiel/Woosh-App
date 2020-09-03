//
//  weatherData.swift
//  workoutApp
//
//  Created by William Gudiel on 8/13/20.
//  Copyright © 2020 William. All rights reserved.
//

struct WeatherData: Codable {
    let name:String
    let main: main
    let weather: [weather]
}
struct main: Codable {
    let temp: Double
}
struct weather: Codable {
    let id: Int
}

