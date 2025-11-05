//
//  Constants.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 03/11/2025.
//

import Foundation

struct Constants {
    
    struct API {
        static let baseURL = "https://api.openweathermap.org/data/2.5"
        static let weatherEndpoint = "/weather"
        
        static let apiKey = "b26fb8d0bedd5182bb47d23c944fc7b8"
        
        static let units = "metric"
    }
    
    struct StorageKeys {
        static let favoriteCityKey = "favoriteCityKey"
    }
    
    
    struct UI {
        static let splashScreenDuration: TimeInterval = 2.0
        static let cornerRadius: CGFloat = 10.0
        static let defaultPadding: CGFloat = 16.0
    }
    
    struct ErrorMessages {
        static let invalidCity = "Please enter a valid city name"
        static let networkError = "Unable to fetch weather data. Please check your internet connection."
        static let apiError = "Weather data unavailable for this city"
        static let unknownError = "An unknown error occurred"
    }
    
    // MARK: - Storyboard Identifiers
    struct StoryboardIDs {
        static let splashViewController = "SplashViewController"
        static let homeViewController = "HomeViewController"
        static let weatherDetailViewController = "WeatherDetailViewController"
    }
}
