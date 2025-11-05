//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 03/11/2025.
//

import Foundation


class WeatherService: WeatherServiceProtocol {
    private let session: URLSession
    
    
    //  - Dependency Injection - URL Session can be injected for testing
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchWeather(for city: String, completion: @escaping (Result<WeatherData, any Error>) -> Void) {
        // City Name
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.failure(WeatherError.invalidCity))
            return
        }
        
        // Build URL
        guard let url = buildWeatherURL(for: city) else {
            completion(.failure(WeatherError.invalidCity))
            return
        }
        
        // Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        // Make API Call
        let task = session.dataTask(with: request) { data, response, error in
            
        // Check for network errors
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(WeatherError.networkError))
                return
            }
            
            // Check response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(WeatherError.unknown))
                return
            }
            
            // Handle different status codes
            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 404 {
                    completion(.failure(WeatherError.apiError(message: "City not found")))
                } else {
                    completion(.failure(WeatherError.apiError(message: "Server error: \(httpResponse.statusCode)")))
                }
                return
            }
            
            // Check data
            guard let data = data else {
                completion(.failure(WeatherError.unknown))
                return
            }
            
            // Decode response
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                let weatherData = WeatherData(from: weatherResponse)
                completion(.success(weatherData))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(WeatherError.decodingError))
            }
        }
        task.resume()
    }
    
    
    private func buildWeatherURL(for city: String) -> URL? {
        var components = URLComponents(string: Constants.API.baseURL + Constants.API.weatherEndpoint)
        
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: Constants.API.apiKey),
            URLQueryItem(name: "units", value: Constants.API.units)
        ]
        return components?.url
    }
}
