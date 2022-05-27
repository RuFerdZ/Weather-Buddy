//
//  WeatherDataResponse.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation

struct WeatherData: Decodable {
    let name: String?
    let weather: [Weather]?
    let main: Main?
    let clouds: Cloud?
    let wind: Wind?
    let message: String?
    let coord: Coord
}
