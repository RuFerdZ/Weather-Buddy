//
//  OpenWeatherAPI.swift
//  WeatherDataApp
//
//  Created by Rusiru Fernando on 5/16/22.
//

import Foundation
import MapKit
import Combine

class OpenWeatherAPI: ObservableObject {
    
    // this holds the state of the weather
    @Published var weather: WeatherViewModel?
    
    // this holds the daily forecast data
    @Published var dailyForecast: [DailyForecastViewModel]?
    
    // this holds the hourly forecast data
    @Published var hourlyForecast: [HourlyForecastViewModel]?
    
    // class containing resuable functions
    var converter = Converter()
    
    // holds the state of the request
    @Published var isLoading: Bool = false
    
    // holds the status of the request
    @Published var isFound: Bool = true
    
    // boilerplate request for One-Time weather API call
    func oneTimeBaseRequest(url: String, unit: WeatherUnit = WeatherUnit.metric) async {
        // clear any previous data
        self.weather = nil
                
        // make sure that we can parse the above url String to a URL
        guard let url = URL(string: url) else { return }
        
        do {
            // make the API call
            let (data, _) = try await URLSession.shared.data(from: url)
                        
            // try to convert JSON response to WeatherData Object
            if let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                // Dispatch any previous threads to the main thread
                DispatchQueue.main.async {
                    self.weather = self.converter.getWeatherViewModel(data: weather, unit: unit)
                    self.isLoading = false
                    self.isFound = true
                }
            } else {
                // incase the requested data was not found
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isFound = false
                }
            }
        } catch {
            print("Error Getting One-time API call: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    // boilerplate request for daily forecast weather API call
    func dailyForecastBaseRequest(url: String, unit: WeatherUnit = WeatherUnit.metric) async {
        
        DispatchQueue.main.async {
            // clears any previous data
            self.dailyForecast = nil
        }
        
        // make sure that we can parse the above url String to a URL
        guard let url = URL(string: url) else { return }
        
        do {
            // make the API call
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // try to convert JSON response to DailyForecast Object
            if let weather = try? JSONDecoder().decode(DailyForecast.self, from: data) {
                // Dispatch any previous threads to the main thread
                DispatchQueue.main.async {
                    self.dailyForecast = self.converter.getDailyForecastViewModel(data: weather)
                    self.isLoading = false
                    self.isFound = true
                }
            } else {
                self.isLoading = false
                self.isFound = false
            }
        } catch {
            self.isLoading = false
            print("Error Getting Forecast API call: \(error.localizedDescription)")
        }
    }
    
    // boilerplate request for hourly forecast weather API call
    func hourlyForecastBaseRequest(url: String, unit: WeatherUnit = WeatherUnit.metric) async {
        self.hourlyForecast = nil
        
        // make sure that we can parse the above url String to a URL
        guard let url = URL(string: url) else { return }
        
        do {
            // make the API call
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // try to convert JSON response to HourlyForecast Object
            if let weather = try? JSONDecoder().decode(HourlyForecast.self, from: data) {
                // Dispatch any previous threads to the main thread
                DispatchQueue.main.async {
                    self.hourlyForecast = self.converter.getHourlyForecastViewModal(data: weather)
                    self.isLoading = false
                    self.isFound = true
                }
               
            } else {
                self.isLoading = false
                self.isFound = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                print("Error Getting Hourly Forecast API call: \(error.localizedDescription)")
            }
        }
    }
    
    // API call to get current user location
    func getCurrentLocation(locationManager: LocationManager, unit: WeatherUnit = WeatherUnit.metric) async {
        self.isLoading = true
        
        // get user current location
        let coordinates = locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D()
        let lat = "\(coordinates.latitude)"
        let lon = "\(coordinates.longitude)"
        
        // constructing our URL
        let url = "\(API.currentWeatherBaseURL)&lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)"
                
       await oneTimeBaseRequest(url: url, unit: unit)
    }
    
    // API call to get weather details by location name
    func getDetailsByCity(city: String, unit: WeatherUnit) async {
        self.isLoading = true
        
        // replace " " with "+" to set into the URL
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        
        let url = "\(API.currentWeatherBaseURL)&q=\(formattedCity)&units=\(unit)"

        await oneTimeBaseRequest(url: url, unit: unit)
    }
    
    // API call to get daily weather forecast
    func getDailyForecast(city: String, unit: WeatherUnit = WeatherUnit.metric) async {
        self.isLoading = true
        // empty forcasts list
        dailyForecast = nil
        
        // replace " " with "+" to set into the URL
        let formattedCity = city.replacingOccurrences(of: " ", with: "+")
        
        // get latitude and longitude by location
        let locationUrl = "\(API.currentWeatherBaseURL)&q=\(formattedCity)&units=\(unit)"
        var locationWeather: WeatherData?

        // make sure that we can parse the above url String to a URL
        guard let locationUrl = URL(string: locationUrl) else { return }
        
        do {
            // make the API call
            let (data, _) = try await URLSession.shared.data(from: locationUrl)
            
            // convert JSON response to WeatherData Object
            if let weather = try? JSONDecoder().decode(WeatherData.self, from: data) {
                locationWeather = weather
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.isFound = false
                    
                }
                return
            }
        } catch {
            self.isLoading = false
            print("Error Getting One-time API call: \(error.localizedDescription)")
        }
        
        // check if there is a valid location
        if (locationWeather == nil) { return }
        
        // set coordinates
        let lat = Double(locationWeather?.coord.lat ?? 0)
        let lon = Double(locationWeather?.coord.lon ?? 0)
        
        // which data we done want from the api
        let exclude = "current,minutely,hourly,alerts"
        
        // construct url
        let url = "\(API.oneCallBaseURL)&lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)&exclude=\(exclude)"
                
        await dailyForecastBaseRequest(url: url, unit: unit)
    }
    
    func getHourlyForecast(unit: WeatherUnit = WeatherUnit.metric, locationManager: LocationManager) async {
        self.isLoading = true
        
        // empty forcasts list
        hourlyForecast = []
        
        // get user current location
        let coordinates = locationManager.location != nil ? locationManager.location!.coordinate : CLLocationCoordinate2D()
        let lat = "\(coordinates.latitude)"
        let lon = "\(coordinates.longitude)"
        
        // configure URL
        let url = "\(API.forecastBaseURL)&lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)"
                        
        await hourlyForecastBaseRequest(url: url, unit: unit)
    }
    
    // API call to get weather icon
    func getWeatherIcon(iconString: String = "03d") -> URL {
        
        let url = "https://openweathermap.org/img/wn/\(iconString)@2x.png"
        
        return URL(string: url)!
    }
}

