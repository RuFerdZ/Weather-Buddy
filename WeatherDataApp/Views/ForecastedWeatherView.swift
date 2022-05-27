//
//  ForecastedWeatherView.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation
import SwiftUI
import MapKit
import SDWebImageSwiftUI

struct ForcastedWeatherView: View {
    
    // initialise location manager as an observable object
    @ObservedObject var locationManager = LocationManager()
    
    // initialise api as an state object
    @StateObject var api = OpenWeatherAPI()
    
    // holds the unit type the result is in
    @State private var unit = WeatherUnit.metric
    
    // holds the search location string
    @State private var searchString = ""
    
    // controls the validity of the search string, i.e. location
    @State private var isValidString = true
    
    // used to format date
    let dateFormatter = DateFormatter()
    
    init() {
        // set the date format
        dateFormatter.dateFormat = "E, MMM, d"
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text("Mobile Weather")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // picket to select the units
                Picker("Units", selection: $unit) {
                    Text("°C").tag(WeatherUnit.metric)
                    Text("°F").tag(WeatherUnit.imperial)
                }
                .disabled(searchString.isEmpty || !isValidString) // disables the picker if criteria not met
                .pickerStyle(.segmented)
                .frame(width: 100)
                .padding(.bottom)
                HStack {
                    TextField("Enter Location", text: $searchString)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            // clear search field
                            Button(action: {
                                searchString = ""
                                api.dailyForecast = []
                                unit = .metric
                                api.isFound = true
                            }) {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(Color.gray)
                            }
                                .padding(.horizontal),
                            alignment: .trailing
                        )
                        .onChange(of: searchString, perform: {_ in
                            // check for the validity of the search string
                            isValidString = Utils.containsSpecialCharactersOrNumbers(text: searchString)
                        })
                    Button {
                        // use to hide the keyboard
                        UIApplication.shared.endEditing()
                        Task {
                            await api.getDailyForecast(city: searchString, unit: unit)
                        }
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    }.disabled(searchString.isEmpty || !isValidString) // disables the search button if criteria not met
                }
                // check if a location provided contain restricted characters
                if !isValidString {
                    Text("⚠️ Location cannot contain numbers or special characters")
                        .padding()
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    // if there is forecast data
                    if let data = api.dailyForecast {
                        // prefix = 6, because current weather + (5 * forecasted weather)
                        List((data.prefix(6)), id: \.date) { day in
                            VStack(alignment: .leading) {
                                Text(dateFormatter.string(from: day.date))
                                    .fontWeight(.bold)
                                HStack(alignment: .center) {
                                    WebImage(url: api.getWeatherIcon(iconString: day.weatherIconString))
                                        .resizable()
                                        .placeholder {
                                            Image(systemName: "hourglass")
                                        }
                                        .scaledToFit()
                                        .frame(width: 75)
                                    VStack(alignment: .leading) {
                                        Text(day.weatherDescription.capitalized)
                                            .font(.title2)
                                        HStack {
                                            Text("H: \(day.maxTempAsString)°")
                                            Text("L: \(day.minTempAsString)°")
                                        }
                                        HStack {
                                            Text("☁️ \(day.clouds)%")
                                            Text("💧 \(day.popAsString)%")
                                        }
                                        Text("Humidity: \(day.humidity)%")
                                    }
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                    } else if (!api.isFound) {
                        // if location not found
                        Text("❌ Location Not Found!")
                            .padding()
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    } else {
                        Spacer()
                    }
                }
            }
            .padding()
            .onChange(of: unit, perform: {_ in
                // fetches the unit converted weather data
                Task {
                    await api.getDailyForecast(city: searchString, unit: unit)
                }
            })
            if (api.isLoading) {
                // this shows the loading spinner until data is loaded
                ZStack {
                    Color(.white)
                        .opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView("Loading Weather")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: 10)
                }
            }
        }
    }
}


