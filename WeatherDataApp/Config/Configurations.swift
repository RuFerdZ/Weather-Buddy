//
//  Configurations.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation
import SwiftUI

enum API {
    // OpenWeather API key
    static let key: String = "f065de1e321123b28ead02f69bd72468"
    // OpenWeatherAPI base URL
    static let currentWeatherBaseURL: String = "https://api.openweathermap.org/data/2.5/weather?appid=\(API.key)"
    static let oneCallBaseURL: String = "https://api.openweathermap.org/data/2.5/onecall?appid=\(API.key)"
    static let forecastBaseURL: String = "https://api.openweathermap.org/data/2.5/forecast?appid=\(API.key)"
}

// this enum represents the unit type that is been used to represtn the data
enum WeatherUnit: String, Equatable {
    case standard = "standard"
    case metric = "metric"
    case imperial = "imperial"
}

enum Timezones: String, Equatable {
    case LK = "+0530"
    case DEFAULT = "+0000"
}

