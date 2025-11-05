//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 03/11/2025.
//

import Foundation


// MARK: - Weather API Response Models
struct WeatherResponse: Codable {
    let coord: Coordinate?
    let weather: [Weather]
    let base: String?
    let main: MainWeatherData
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int
    let sys: System?
    let timezone: Int?
    let id: Int
    let name: String
    let cod: Int
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainWeatherData: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int?
}

struct Clouds: Codable {
    let all: Int
}

struct System: Codable {
    let type: Int?
    let id: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
