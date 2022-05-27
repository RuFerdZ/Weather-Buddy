//
//  HourlyForecastViewModel.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/20/22.
//

import Foundation

struct HourlyForecastViewModel {
    let date: Date
    let id: Int
    let description: String
    let icon: String
    let pop: Double
    let temperature: Float
    
    // get temperature in 1 decimal place
    var tempAsString: String {
        return String(format: "%.1f", temperature)
    }
}
