//
//  MockServices.swift
//  WeatherAppTests
//
//  Created by Oyewale Favour on 05/11/2025.
//

import Foundation
@testable import WeatherApp

// MARK: - Mock Weather Service
class MockWeatherService: WeatherServiceProtocol {
    
    var shouldSucceed = true
    var mockWeatherData: WeatherData?
    var mockError: Error?
    var fetchWeatherCallCount = 0
    var lastCitySearched: String?
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        fetchWeatherCallCount += 1
        lastCitySearched = city
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.shouldSucceed {
                if let weatherData = self.mockWeatherData {
                    completion(.success(weatherData))
                } else {
                    let defaultWeather = WeatherData(
                        cityName: city,
                        temperature: 25.0,
                        feelsLike: 24.0,
                        weatherDescription: "clear sky",
                        weatherMain: "Clear",
                        humidity: 60,
                        pressure: 1013,
                        windSpeed: 3.5,
                        tempMin: 22.0,
                        tempMax: 28.0
                    )
                    completion(.success(defaultWeather))
                }
            } else {
                let error = self.mockError ?? WeatherError.networkError
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Mock Storage Service
class MockStorageService: StorageServiceProtocol {
    
    private var storage: [String: String] = [:]
    var saveFavoriteCityCallCount = 0
    var getFavoriteCityCallCount = 0
    var removeFavoriteCityCallCount = 0
    
    func saveFavoriteCity(_ city: String) {
        saveFavoriteCityCallCount += 1
        storage[Constants.StorageKeys.favoriteCityKey] = city
    }
    
    func getFavoriteCity() -> String? {
        getFavoriteCityCallCount += 1
        return storage[Constants.StorageKeys.favoriteCityKey]
    }
    
    func removeFavoriteCity() {
        removeFavoriteCityCallCount += 1
        storage.removeValue(forKey: Constants.StorageKeys.favoriteCityKey)
    }
}
