//
//  HourlyForecast.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/20/22.
//

import Foundation

struct HourlyForecast: Decodable {
    let list: [Hourly]
}
