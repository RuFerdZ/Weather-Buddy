//
//  HomeView.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    // get from the environment
    @EnvironmentObject var locationManager: LocationManager
        
    // initialise api as an state object
    @StateObject var api = OpenWeatherAPI()
    
    // used to format datetime
    let dateFormatter = DateFormatter()
    
    init() {
        // set the date/time formats
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
    }
    
    var body: some View {
        ZStack {
            // ignores the safespace boudaries and fill the entire screen
//            Color.blue
//                .ignoresSafeArea()
            Image(api.weather?.backgroundImage ?? "cloudy")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text (api.weather?.location ?? "--")
                    .font(.system(size: 45, weight: .medium, design: .rounded))
                
                Text(dateFormatter.string(from: Date()))
                
                Text("\(api.weather?.tempAsWholeNumberString ?? "--")°C")
                    .font(.system(size: 70, weight: .black, design: .rounded))
                    .foregroundStyle(Color.yellow)
                    .padding()
                Image(systemName: api.weather?.weatherIcon ?? "cloud")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                                
                Text(api.weather?.description.capitalized ?? "--")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding()
            }
            .foregroundColor(.white)
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
        }.onAppear() {
            // this fetches the current location details as the view loads
            Task{
                await api.getCurrentLocation(locationManager: locationManager)
            }
        }
    }
}
