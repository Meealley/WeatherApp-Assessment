//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 04/11/2025.
//

import Foundation


class HomeViewModel {
    
    private let weatherService: WeatherServiceProtocol
    private let storageService: StorageServiceProtocol
    
    
    
    var onWeatherFetched: ((WeatherData) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    
    // State Management
    private(set) var isLoading = false {
        didSet {
            // Notify view when loading state changes
            onLoadingStateChanged?(isLoading)
        }
    }
    
    init(weatherService: WeatherServiceProtocol, storageService: StorageServiceProtocol) {
        self.weatherService = weatherService
        self.storageService = storageService
    }
    
    
    // Validates if city name is valid
    func validateCityName(_ cityName: String) -> Bool {
        let trimmedCity = cityName.trimmingCharacters(in: .whitespaces)
        return !trimmedCity.isEmpty && trimmedCity.count >= 2
    }
    
        // Fetch weather data for the given city
    func fetchWeather(for city: String) {
        // Validate Input
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            onError?(Constants.ErrorMessages.invalidCity)
            return
        }
        
        isLoading = true
        
        weatherService.fetchWeather(for: city) { [weak self] result in
            
        // UI updates on main thread
            
        DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let weatherData):
                    self?.onWeatherFetched?(weatherData)
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    // Save favorite city to storage
    func saveFavoriteCity(_ city: String) {
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        storageService.saveFavoriteCity(city)
    }
    
    // Retrieve the saved favorite city
    func getFavoriteCity() -> String? {
        return storageService.getFavoriteCity()
    }
    
    // Remove the favorite city from storage
    func removeFavoriteCity() {
        storageService.removeFavoriteCity()
    }
    
    
    
    
}
