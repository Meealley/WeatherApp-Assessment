//
//  ServiceProtocols.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 03/11/2025.
//

import Foundation


protocol WeatherServiceProtocol {
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherData, Error>) -> Void)
}


// MARK: - Storage Procol
protocol StorageServiceProtocol {
    func saveFavoriteCity(_ city: String)
    func getFavoriteCity() -> String?
    func removeFavoriteCity()
}

// MARK: - Custom Errors
enum WeatherError: Error, LocalizedError {
    case invalidCity
    case networkError
    case decodingError
    case apiError(message: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCity:
            return Constants.ErrorMessages.invalidCity
        case .networkError:
            return Constants.ErrorMessages.networkError
        case .decodingError:
            return Constants.ErrorMessages.networkError
        case .apiError(message: let message):
            return message
        case .unknown:
            return Constants.ErrorMessages.unknownError
        }
    }
}
