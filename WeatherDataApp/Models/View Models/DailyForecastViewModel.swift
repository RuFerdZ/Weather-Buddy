//
//  ForecastViewModel.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/19/22.
//

import Foundation

struct DailyForecastViewModel {
    let date: Date
    let maxTemperature: Double
    let minTemperature: Double
    let humidity: Int
    let clouds: Int
    let pop: Double
    let weatherID: Int
    let weatherDescription: String
    let weatherIconString: String

    // get max temperature in 1 decimal place
    var maxTempAsString: String {
        return String(format: "%.1f", maxTemperature)
    }
    
    // get min temperature in 1 decimal place
    var minTempAsString: String {
        return String(format: "%.1f", minTemperature)
    }
    
    // get precipitation in 1 decimal place
    var popAsString: String {
        return String(format: "%.1f", pop)
    }
}
