//
//  UserDefaultStorageService.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 04/11/2025.
//


import Foundation

class UserDefaultsStorageService: StorageServiceProtocol {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        print("UserDefaultsStorageService initialized")
    }
    
    func saveFavoriteCity(_ city: String) {
        print("SAVING city to UserDefaults...")
        print("   Key: '\(Constants.StorageKeys.favoriteCityKey)'")
        print("   Value: '\(city)'")
        
        userDefaults.set(city, forKey: Constants.StorageKeys.favoriteCityKey)
        userDefaults.synchronize()
        
        // Verify immediately
        let verification = userDefaults.string(forKey: Constants.StorageKeys.favoriteCityKey)
        print("VERIFICATION: '\(verification ?? "nil")'")
        
        if verification == city {
            print("Save successful!")
        } else {
            print("Save failed!")
        }
    }
    
    func getFavoriteCity() -> String? {
        let city = userDefaults.string(forKey: Constants.StorageKeys.favoriteCityKey)
        print("READING from UserDefaults...")
        print(" Key: '\(Constants.StorageKeys.favoriteCityKey)'")
        print(" Value: '\(city ?? "nil")'")
        return city
    }
    
    func removeFavoriteCity() {
        print("REMOVING from UserDefaults...")
        print("Key: '\(Constants.StorageKeys.favoriteCityKey)'")
        userDefaults.removeObject(forKey: Constants.StorageKeys.favoriteCityKey)
        userDefaults.synchronize()
    }
}
