//
//  StorageServiceTests.swift
//  WeatherAppTests
//
//  Created by Oyewale Favour on 05/11/2025.
//

import XCTest
@testable import WeatherApp

class UserDefaultsStorageServiceTests: XCTestCase {
    
    var sut: UserDefaultsStorageService!
    var mockUserDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = UserDefaults(suiteName: "TestSuite")!
        mockUserDefaults.removePersistentDomain(forName: "TestSuite")
        sut = UserDefaultsStorageService(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        mockUserDefaults.removePersistentDomain(forName: "TestSuite")
        sut = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    func testSaveFavoriteCity_SavesCorrectly() {
        let testCity = "Paris"
        
        sut.saveFavoriteCity(testCity)
        
        let savedCity = mockUserDefaults.string(forKey: Constants.StorageKeys.favoriteCityKey)
        XCTAssertEqual(savedCity, testCity)
    }
    
    func testGetFavoriteCity_ReturnsSavedCity() {
        let testCity = "Tokyo"
        mockUserDefaults.set(testCity, forKey: Constants.StorageKeys.favoriteCityKey)
        
        let result = sut.getFavoriteCity()
        
        XCTAssertEqual(result, testCity)
    }
    
    func testGetFavoriteCity_WhenNoCitySaved_ReturnsNil() {
        let result = sut.getFavoriteCity()
        
        XCTAssertNil(result)
    }
}
