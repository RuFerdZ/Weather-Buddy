//
//  HourlyDaily.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/20/22.
//

import Foundation

struct Hourly: Decodable {
    let dt: Date
    let weather: [Weather]
    let pop: Double
    let main: Main
    let dt_txt: String
}
