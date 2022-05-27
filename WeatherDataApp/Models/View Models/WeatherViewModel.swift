//
//  WeatherViewModel.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation
import SwiftUI

struct WeatherViewModel {
    let id: Int
    let location: String
    let temperature: Double
    let description: String
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let windDirection: Int
    let cloudPercentage: Int
    let unit: WeatherUnit
    let lat: Double
    let lon: Double
    let icon: String
    
    // get temperature in 1 decimal place
    var tempAsString: String {
        return String(format: "%.1f", temperature)
    }
    
    var tempAsWholeNumberString: String {
        return String(format: "%.0f", temperature)
    }
    
    // set the weather icon string based on the weather id
    // haven't used the inbuild OpenWeatherAPI icons since enlargment of the icons result in bluriness
    var weatherIcon: String {
        switch id {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801:
                return "cloud.sun"
            case 802...804:
                return "cloud"
            default:
                return "cloud"
        }
    }
    
    // set the app background based on the weather
    var backgroundImage: String {
        switch id {
            case 200...232:
                return "storm"
            case 300...321:
                return "drizzle"
            case 500...531:
                return "rain"
            case 600...622:
                return "snow"
            case 701...781:
                return "fog"
            case 800:
                return "sun"
            case 801:
                return "cloudy"
            case 802...804:
                return "cloudy"
            default:
                return "cloudy"
        }
    }
    
    // get the temperature in the required imperial-metric units
    var tempInUnit: String {
        if (unit == WeatherUnit.imperial){
            return ("\(tempAsString) °F")
        }
        return ("\(tempAsString) °C")
    }
    
    // get the windpeed in the required imperial-metric units
    var windSpeedInUnit: String {
        if (unit == WeatherUnit.imperial){
            return ("\(windSpeed) mph")
        }
        return ("\(windSpeed) m/s")
    }
    
    // get the wind direction via the degree
    var windDirectionAsCoordinate: String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
      
        let index = round(round(((Double(windDirection).truncatingRemainder(dividingBy: 360)) < 0 ? Double(windDirection) + 360 : Double(windDirection)) / 45).truncatingRemainder(dividingBy: 8))
        return directions[Int(index)]
    }
    
    // convert pressure passed on the imperial-metric standards (this is not been converted via the API)
    var pressureInUnits: String {
        if (unit == WeatherUnit.imperial){
            let psi = Double(pressure) * 0.0145037738
            return (String(format: "%.1f", psi) + " PSI" )
        }
        return ("\(pressure) hPa" )
    }
    
    // populate the list with the required location details
    var searchResult: [WeatherDetailViewModel] {
        return [
            .init(icon: "thermometer", iconColor: Color.red, key: "Temperature", value: tempInUnit),
            .init(icon: "drop.fill", iconColor: Color.blue, key: "Humidity", value: "\(humidity)%"),
            .init(icon: "digitalcrown.horizontal.press.fill", iconColor: Color.green, key: "Pressure", value: pressureInUnits),
            .init(icon: "wind", iconColor: Color.orange, key: "Wind Speed", value: windSpeedInUnit),
            .init(icon: "arrow.up.left.circle", iconColor: Color.yellow, key: "wind Direction", value: windDirectionAsCoordinate),
            .init(icon: "icloud", iconColor: Color.cyan, key: "Cloud Percentage", value: "\(cloudPercentage)%")
        ]
    }
}
