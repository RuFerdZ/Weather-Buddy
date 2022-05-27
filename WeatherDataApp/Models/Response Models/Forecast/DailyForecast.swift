//
//  ForecastWeatherData.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/19/22.
//

import Foundation

struct DailyForecast: Decodable {
    let daily: [Daily]
}
