//
//  ContentView.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import SwiftUI

struct ContentView: View {
    
    // initialise location manager as an observed object
    @ObservedObject var locationManager = LocationManager()
    
    init() {
        // set tab bar appearance
        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().barTintColor = UIColor(named: "secondary")
    }
    
    var body: some View {
        // the tabs within the application
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .environmentObject(locationManager)
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            ForcastedWeatherView()
                .tabItem {
                    Label("Forecast", systemImage: "goforward")
                }
            IntervalWeatherView()
                .tabItem {
                    Label("Intervals", systemImage: "deskclock")
                }
                .environmentObject(locationManager)
        }
        .accentColor(Color.orange)
    }
}
