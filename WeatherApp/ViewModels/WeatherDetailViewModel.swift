//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 04/11/2025.
//

import Foundation


class WeatherDetailViewModel {
    private let weatherData: WeatherData
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
    }

    
        var cityName: String {
            return weatherData.cityName
        }
        
        var temperature: String {
            return weatherData.temperatureString
        }
        
        var weatherDescription: String {
            return weatherData.capitalizedDescription
        }
        
        var feelsLike: String {
            return weatherData.feelsLikeString
        }
        
        var humidity: String {
            return "Humidity: \(weatherData.humidity)%"
        }
        
        var pressure: String {
            return "Pressure: \(weatherData.pressure) hPa"
        }
    
        var windSpeed: String {
            return String(format: "Wind: %.1f m/s", weatherData.windspeed)
        }
        
        var temperatureRange: String {
            return String(format: "Min: %.1f°C / Max: %.1f°C",
                         weatherData.tempMin, weatherData.tempMax)
        }
        
        var weatherMain: String {
            return weatherData.weatherMain
        }
    
        
    
    func getFormattedDetails() -> [(String, String)] {
            return [
                ("Temperature", temperature),
                ("Feels Like", feelsLike),
                ("Description", weatherDescription),
                ("Humidity", humidity),
                ("Pressure", pressure),
                ("Wind Speed", windSpeed),
                ("Temperature Range", temperatureRange)
            ]
        }
    
    func getWeatherIconName() -> String {
            let condition = weatherMain.lowercased()
            
            switch condition {
            case "clear":
                return "sun.max.fill"
            case "clouds":
                return "cloud.fill"
            case "rain", "drizzle":
                return "cloud.rain.fill"
            case "thunderstorm":
                return "cloud.bolt.rain.fill"
            case "snow":
                return "snow"
            case "mist", "fog", "haze":
                return "cloud.fog.fill"
            default:
                return "cloud.fill"
            }
        }

}
