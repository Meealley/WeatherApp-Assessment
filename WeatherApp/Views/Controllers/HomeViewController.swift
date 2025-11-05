//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 04/11/2025.
//

import Foundation
import UIKit

// MARK: - Home View Controller
class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var saveFavoriteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel: HomeViewModel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController - viewDidLoad called")
        
        if viewModel == nil {
            print("Dependency Injection Failed")
        } else {
            print("viewModel is properly injected")
        }
        
        setupUI()
        setupBindings()
        loadFavoriteCity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeViewController - viewWillAppear called")
        
        // Hide navigation bar for home screen
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        title = "Weather Search"
        view.backgroundColor = .systemBackground
        
        // Title Label
        titleLabel.text = "Weather Finder"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        // Text Field
        cityTextField.placeholder = "Enter city name"
        cityTextField.borderStyle = .roundedRect
        cityTextField.autocapitalizationType = .words
        cityTextField.returnKeyType = .search
        cityTextField.delegate = self
        cityTextField.layer.cornerRadius = Constants.UI.cornerRadius
        cityTextField.layer.borderWidth = 1
        cityTextField.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Search Button
        searchButton.setTitle("Search Weather", for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = Constants.UI.cornerRadius
        searchButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // Save Favorite Button
        saveFavoriteButton.setTitle("Save as Favorite", for: .normal)
        saveFavoriteButton.backgroundColor = .systemGreen
        saveFavoriteButton.setTitleColor(.white, for: .normal)
        saveFavoriteButton.layer.cornerRadius = Constants.UI.cornerRadius
        saveFavoriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .systemBlue
    }
    
    private func setupBindings() {
       
        
        viewModel.onWeatherFetched = { [weak self] weatherData in
            print("Weather fetched successfully: \(weatherData.cityName)")
            self?.navigateToWeatherDetail(with: weatherData)
        }
        
        viewModel.onError = { [weak self] errorMessage in
            print("Error: \(errorMessage)")
            self?.showError(errorMessage)
        }
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            print("Loading state: \(isLoading)")
            self?.updateLoadingState(isLoading)
        }
    }
    
    private func loadFavoriteCity() {
        print("====================")
        print("Loading favorite city...")
        print("===========")
        
        if let favoriteCity = viewModel.getFavoriteCity() {
            print("Found favorite city: '\(favoriteCity)'")
            cityTextField.text = favoriteCity
            print("Text field updated with: '\(favoriteCity)'")
        } else {
            print("No favorite city found in storage")
        }
        
        
    }
    
    // MARK: - IBActions
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        print("Search button tapped")
        searchWeather()
    }
    
    @IBAction func saveFavoriteButtonTapped(_ sender: UIButton) {
     
        
        // Check ViewModel exists
        if viewModel == nil {
        
            showAlert(title: "Error", message: "App error - please restart")
            return
        }
        print("viewModel exists")
        
        // Check city text
        guard let city = cityTextField.text, !city.isEmpty else {
          
            showAlert(title: "Error", message: "Please enter a city name first")
            return
        }
        
  
        
        viewModel.saveFavoriteCity(city)
        
        print("Save call completed. Now verifying...")
        
        // Verify it was saved
        let savedCity = viewModel.getFavoriteCity()
        print("Verification result: '\(savedCity ?? "nil")'")
        
        if savedCity == city {
            print("City saved and verified!")
        } else {
            print("FAILED: City did NOT save correctly!")
            print("   Expected: '\(city)'")
            print("   Got: '\(savedCity ?? "nil")'")
        }
        
        print("==========================================")
        
        showAlert(title: "Success", message: "City saved as favorite!")
    }
    
    // MARK: - Private Methods
    
    private func searchWeather() {
        // Dismiss keyboard
        view.endEditing(true)
        
        guard let city = cityTextField.text else {
            return
        }
        
        print("Searching weather for: \(city)")
        viewModel.fetchWeather(for: city)
    }
    
    private func navigateToWeatherDetail(with weatherData: WeatherData) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailVC = storyboard.instantiateViewController(
            withIdentifier: Constants.StoryboardIDs.weatherDetailViewController) as? WeatherDetailViewController {
            
            // Inject weather data via ViewModel
            let detailViewModel = WeatherDetailViewModel(weatherData: weatherData)
            detailVC.viewModel = detailViewModel
            
            print("Navigating to detail screen for: \(weatherData.cityName)")
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    private func updateLoadingState(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            searchButton.isEnabled = false
            searchButton.alpha = 0.5
        } else {
            activityIndicator.stopAnimating()
            searchButton.isEnabled = true
            searchButton.alpha = 1.0
        }
    }
    
    private func showError(_ message: String) {
        showAlert(title: "Error", message: message)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchWeather()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow only letters, spaces, and hyphens
        let allowedCharacters = CharacterSet.letters.union(.whitespaces).union(CharacterSet(charactersIn: "-"))
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
