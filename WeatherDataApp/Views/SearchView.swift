//
//  SearchView.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation
import SwiftUI

struct SearchView: View {
    
    // initialise api as an state object
    @StateObject var api = OpenWeatherAPI()

    // controls the validity of the search string, i.e. location
    @State private var isValidString = true
    
    // holds the search string
    @State private var searchString = ""
    
    // holds the units the data is currently been displayed
    @State private var unit = WeatherUnit.metric
    
    var body: some View {
        ZStack {
            VStack {
                Text("Search Location")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                HStack {
                    TextField("Enter a City", text: $searchString)
                        .textFieldStyle(.roundedBorder)
                        .overlay(
                            // clear search field
                            Button(action: {
                                searchString = ""
                                api.weather = nil
                                unit = .metric
                                api.isFound = true // becasue the above nil will make the weather as `not found`
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
                            await api.getDetailsByCity(city: searchString, unit: unit)
                        }
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .padding()
                    }.disabled(searchString.isEmpty || !isValidString) // disables the search button if criteria not met
                }
                // picker to select units
                Picker("Units", selection: $unit){
                    Text("Metric").tag(WeatherUnit.metric)
                    Text("Imperial").tag(WeatherUnit.imperial)
                }.disabled(searchString.isEmpty || !isValidString)  // disables the picker if criteria not met
                .pickerStyle(.segmented)
                // check if a location provided contain restricted characters
                if !isValidString {
                    Text("⚠️ Location cannot contain numbers or special characters")
                        .padding()
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    if let data = api.weather?.searchResult {
                        // if location found
                        List(data) { item in
                            HStack {
                                Image(systemName: item.icon)
                                    .foregroundColor(item.iconColor)
                                Text(item.key)
                                    .font(.system(size: 16, weight: .regular, design: .rounded))
                                Spacer()
                                Text(item.value)
                                    .font(.system(size: 18, weight: .medium, design: .rounded))
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
                Task {
                    // if unit changes, get the new data converted in the relevant unit
                    await api.getDetailsByCity(city: searchString, unit: unit)
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
