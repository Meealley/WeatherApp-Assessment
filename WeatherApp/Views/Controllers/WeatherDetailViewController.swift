//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 04/11/2025.
//

import Foundation
import UIKit

class WeatherDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var temperatureRangeLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    // ViewModel is injected - Dependency Injection
    var viewModel: WeatherDetailViewModel!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WeatherDetailViewController - viewDidLoad called")
        
        setupUI()
        displayWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("WeatherDetailViewController - viewWillAppear called")
        
        // Show navigation bar for detail screen (with back button)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("WeatherDetailViewController - viewWillDisappear called")
        
        // Hide navigation bar when going back to home screen
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        title = "Weather Details"
        view.backgroundColor = .systemBackground
        
        // Configure navigation bar
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        
        // Container View styling
        containerView.layer.cornerRadius = Constants.UI.cornerRadius
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        containerView.backgroundColor = .secondarySystemBackground
        
        // City Name Label
        cityNameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        cityNameLabel.textAlignment = .center
        cityNameLabel.textColor = .label
        
        // Temperature Label
        temperatureLabel.font = UIFont.systemFont(ofSize: 48, weight: .thin)
        temperatureLabel.textAlignment = .center
        temperatureLabel.textColor = .label
        
        // Weather Description Label
        weatherDescriptionLabel.font = UIFont.systemFont(ofSize: 20)
        weatherDescriptionLabel.textAlignment = .center
        weatherDescriptionLabel.textColor = .secondaryLabel
        
        // Feels Like Label
        feelsLikeLabel.font = UIFont.systemFont(ofSize: 16)
        feelsLikeLabel.textAlignment = .center
        feelsLikeLabel.textColor = .secondaryLabel
        
        // Detail Labels
        let detailLabels = [humidityLabel, pressureLabel, windSpeedLabel, temperatureRangeLabel]
        detailLabels.forEach { label in
            label?.font = UIFont.systemFont(ofSize: 16)
            label?.textColor = .label
        }
        
        // Weather Icon
        weatherIconImageView.contentMode = .scaleAspectFit
        weatherIconImageView.tintColor = .systemBlue
    }
    
    private func displayWeatherData() {
        // Get formatted data from ViewModel
        cityNameLabel.text = viewModel.cityName
        temperatureLabel.text = viewModel.temperature
        weatherDescriptionLabel.text = viewModel.weatherDescription
        feelsLikeLabel.text = viewModel.feelsLike
        humidityLabel.text = viewModel.humidity
        pressureLabel.text = viewModel.pressure
        windSpeedLabel.text = viewModel.windSpeed
        temperatureRangeLabel.text = viewModel.temperatureRange
        
        // Set weather icon (SF Symbol)
        let iconName = viewModel.getWeatherIconName()
        weatherIconImageView.image = UIImage(systemName: iconName)
        
        print("Displaying weather for: \(viewModel.cityName)")
        print("Temperature: \(viewModel.temperature)")
        
        // Add fade-in animation
        animateViews()
    }
    
    private func animateViews() {
        let views: [UIView] = [
            cityNameLabel, temperatureLabel, weatherDescriptionLabel,
            feelsLikeLabel, weatherIconImageView, containerView
        ]
        
        // Start with invisible views
        views.forEach { $0.alpha = 0 }
        
        // Animate to visible
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseOut) {
            views.forEach { $0.alpha = 1 }
        }
    }
}
