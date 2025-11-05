//
//  HomeViewModelTests.swift
//  WeatherAppTests
//
//  Created by Oyewale Favour on 05/11/2025.
//

import XCTest
@testable import WeatherApp

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var mockWeatherService: MockWeatherService!
    var mockStorageService: MockStorageService!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockStorageService = MockStorageService()
        sut = HomeViewModel(weatherService: mockWeatherService, storageService: mockStorageService)
    }
    
    override func tearDown() {
        sut = nil
        mockWeatherService = nil
        mockStorageService = nil
        super.tearDown()
    }
    
    func testFetchWeather_WithValidCity_Success() {
        let expectation = XCTestExpectation(description: "Fetch weather successfully")
        let testCity = "London"
        
        var receivedWeatherData: WeatherData?
        sut.onWeatherFetched = { weatherData in
            receivedWeatherData = weatherData
            expectation.fulfill()
        }
        
        sut.fetchWeather(for: testCity)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedWeatherData)
        XCTAssertEqual(receivedWeatherData?.cityName, testCity)
        XCTAssertEqual(mockWeatherService.fetchWeatherCallCount, 1)
    }
    
    func testFetchWeather_WithEmptyCity_ReturnsError() {
        let expectation = XCTestExpectation(description: "Error for empty city")
        var receivedError: String?
        sut.onError = { error in
            receivedError = error
            expectation.fulfill()
        }
        
        sut.fetchWeather(for: "")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(receivedError)
    }
    
    func testFetchWeather_LoadingStateChanges() {
        let expectation = XCTestExpectation(description: "Loading state changes")
        expectation.expectedFulfillmentCount = 2
        
        var loadingStates: [Bool] = []
        sut.onLoadingStateChanged = { isLoading in
            loadingStates.append(isLoading)
            expectation.fulfill()
        }
        
        sut.fetchWeather(for: "London")
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(loadingStates, [true, false])
    }
    
    func testSaveFavoriteCity_Success() {
        let testCity = "Paris"
        
        sut.saveFavoriteCity(testCity)
        
        XCTAssertEqual(mockStorageService.saveFavoriteCityCallCount, 1)
        XCTAssertEqual(mockStorageService.getFavoriteCity(), testCity)
    }
    
    func testGetFavoriteCity_ReturnsStoredCity() {
        let testCity = "Tokyo"
        mockStorageService.saveFavoriteCity(testCity)
        
        let favoriteCity = sut.getFavoriteCity()
        
        XCTAssertEqual(favoriteCity, testCity)
    }
    
    func testValidateCityName_WithValidName_ReturnsTrue() {
        XCTAssertTrue(sut.validateCityName("London"))
        XCTAssertTrue(sut.validateCityName("New York"))
    }
    
    func testValidateCityName_WithInvalidName_ReturnsFalse() {
        XCTAssertFalse(sut.validateCityName(""))
        XCTAssertFalse(sut.validateCityName("A"))
    }
}
