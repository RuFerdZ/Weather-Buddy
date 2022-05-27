//
//  WeatherDetailViewModel.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/17/22.
//

import Foundation
import SwiftUI

// this holds an single weather detail of the weather details of a location
struct WeatherDetailViewModel: Identifiable {
    let id = UUID()
    let icon: String
    let iconColor: Color
    let key: String
    let value: String
}
