//
//  Daily.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/19/22.
//

import Foundation

struct Daily: Decodable {
    let dt: Date
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
    let clouds: Int
    let pop: Double
}
