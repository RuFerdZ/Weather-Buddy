//
//  Weather.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation

struct Weather: Decodable {
    let id: Int
    let description: String
    let icon: String
}
