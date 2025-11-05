//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 03/11/2025.
//

import Foundation


struct WeatherData {
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let weatherDescription: String
    let weatherMain: String
    let humidity: Int
    let pressure: Int
    let windspeed: Double
    let tempMin: Double
    let tempMax: Double
    
    
    var temperatureString: String {
        return String(format: "%.1f°C", temperature)
    }
    
    var feelsLikeString: String {
        return String(format: "Feels like %.1f°C", feelsLike)
    }
    
    var capitalizedDescription: String {
        return weatherDescription.capitalized
    }
    
    
    // MARK: - Initialize from API response
    init(from response: WeatherResponse) {
        self.cityName = response.name
        self.temperature = response.main.temp
        self.feelsLike = response.main.feelsLike
        self.weatherDescription = response.weather.first?.description ?? "N/A"
        self.weatherMain = response.weather.first?.main ?? "N/A"
        self.humidity = response.main.humidity
        self.pressure = response.main.pressure
        self.windspeed = response.wind?.speed ?? 0.0
        self.tempMin = response.main.tempMin
        self.tempMax = response.main.tempMax
    }
    
    // MARK: - FOR testing purposes
    init(cityName: String, temperature: Double, feelsLike: Double ,weatherDescription: String, weatherMain: String, humidity: Int, pressure: Int, windSpeed: Double, tempMin: Double, tempMax: Double){
        self.cityName = cityName
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.weatherDescription = weatherDescription
        self.weatherMain = weatherMain
        self.humidity = humidity
        self.pressure = pressure
        self.windspeed = windSpeed
        self.tempMin = tempMin
        self.tempMax = tempMax
    }
}
