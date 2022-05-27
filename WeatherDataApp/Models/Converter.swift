//
//  Converter.swift
//  WeatherDataApp
//
//  Created by user215753 on 5/16/22.
//

import Foundation

class Converter {
    // to store the current weather(one time) view model
    var onetimeViewModal: WeatherViewModel!
    
    // to store the list of daily forecast view models
    var dailyForecastViewModals: [DailyForecastViewModel]!
    
    // to store the list of hourly forecasat view models
    var hourlyForecastViewModals: [HourlyForecastViewModel]!
    
    // function to convert current weather to its viewm-odel
    func getWeatherViewModel(data: WeatherData, unit: WeatherUnit = WeatherUnit.metric) -> WeatherViewModel {
        onetimeViewModal = WeatherViewModel(
            id: data.weather?.first!.id ?? 0,
            location: data.name ?? "--",
            temperature: Double(data.main?.temp ?? 0),
            description: data.weather?.first!.description ?? "--",
            humidity: data.main?.humidity ?? 0,
            pressure: data.main?.pressure ?? 0,
            windSpeed: data.wind?.speed ?? 0,
            windDirection: data.wind?.deg ?? 0,
            cloudPercentage: data.clouds?.all ?? 0,
            unit: unit,
            lat: data.coord.lat,
            lon: data.coord.lon,
            icon: data.weather?.first?.icon ?? "03d"
        )
         
        return onetimeViewModal
    }
    
    // function to convert daily forecast to its view-model
    func getDailyForecastViewModel(data: DailyForecast) -> [DailyForecastViewModel] {
        dailyForecastViewModals = []

        for daily in data.daily {
            let viewModel = DailyForecastViewModel(
                date: daily.dt,
                maxTemperature: daily.temp.max,
                minTemperature: daily.temp.min,
                humidity: daily.humidity,
                clouds: daily.clouds,
                pop: daily.pop,
                weatherID: daily.weather.first?.id ?? 0,
                weatherDescription: daily.weather.first?.description ?? "",
                weatherIconString: daily.weather.first?.icon ?? "")

            dailyForecastViewModals.append(contentsOf: [viewModel])
        }
        return dailyForecastViewModals
    }
    
    // function to convert hourly forecast to its view-modal
    func getHourlyForecastViewModal(data: HourlyForecast) -> [HourlyForecastViewModel] {
        hourlyForecastViewModals = []
        
        for list in data.list {
            
            // get iso date
            let date = Utils.getISODate(date: list.dt_txt)

            // check whether date is within the current + 3 day limit
            if (!Utils.isDaysOutOfRange(days: 3, date: date)) {
                continue
            }
            
            let viewModel = HourlyForecastViewModel(
                date: date,
                id: list.weather.first!.id,
                description: list.weather.first!.description,
                icon: list.weather.first!.icon,
                pop: list.pop,
                temperature: list.main.temp)
            
            hourlyForecastViewModals.append(contentsOf: [viewModel])
        }
        return hourlyForecastViewModals
    }
    
}
