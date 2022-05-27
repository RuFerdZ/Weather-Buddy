//
//  IntevallWeatherView.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct IntervalWeatherView: View {
    
    // get from the environment
    @EnvironmentObject var locationManager: LocationManager
    
    // initialise api as an state object
    @StateObject var api = OpenWeatherAPI()
    
    // holds the unit type the result is in
    @State private var unit = WeatherUnit.metric
    
    // holds the search location string
    @State private var searchString = ""
    
    // used to format datetime
    let dateTimeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    let timeFormater = DateFormatter()
    
    init() {
        // set the date/time formats
        dateTimeFormatter.dateFormat = "MMMM d, yyyy, h:mm:ss a"
        dateFormatter.dateFormat = "MMMM d, yyyy"
        timeFormater.dateFormat = "h:mm:ss a"
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(dateTimeFormatter.string(from: Date()))
                    .padding(.top)
                HStack {
                    Image(systemName: api.weather?.weatherIcon ?? "cloud")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text((api.weather?.tempAsString ?? "0") + "°")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundColor(.orange)
                }
                Text(api.weather?.description.capitalized ?? "")
                let forecast = api.hourlyForecast
                if (forecast != nil) {
                    // prefix set to get dates of current day + next 3 days
                    List((forecast)!, id: \.date) { day in
                        Section {
                            HStack(spacing: 20) {
                                WebImage(url: api.getWeatherIcon(iconString: day.icon))
                                    .resizable()
                                    .placeholder {
                                        Image(systemName: "hourglass")
                                    }
                                    .scaledToFit()
                                    .frame(width: 75)
                                VStack(alignment: .leading) {
                                    Text(day.description.capitalized)
                                    // used the date and time in 2 seperate lines as month length increases, it will affect the formatting
                                    Text(dateFormatter.string(from: day.date))
                                        .font(.system(size: 16, weight: .light))
                                    Text(timeFormater.string(from: day.date))
                                        .font(.system(size: 16, weight: .light))
                                }
                                Spacer()
                                Text(day.tempAsString + "°")
                                    .padding()
                            }
                        }
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Spacer()
                }
            }
            // on view load run the below code
            .onAppear() {
                Task{
                    await api.getHourlyForecast(unit: unit, locationManager: locationManager)
                    await api.getCurrentLocation(locationManager: locationManager)
                }
            }
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
