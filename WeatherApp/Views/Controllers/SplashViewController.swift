//
//  SplashViewController.swift
//  WeatherApp
//
//  Created by Oyewale Favour on 04/11/2025.
//

import UIKit


class SplashViewController: UIViewController {
    
    // Connect to Storyboard
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print("SplashViewController - viewDidLoad called")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("SplashViewController - viewDidAppear called")
        
        // Nav to HomeScreen after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.UI.splashScreenDuration) { [weak self] in
            self?.navigateToHome()
        }
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBlue
        appNameLabel.text = "Weather App"
        appNameLabel.textColor = .white
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 32)
        appNameLabel.textAlignment = .center
        // Activity Indicator
        activityIndicator.startAnimating()
        activityIndicator.color = .white
        
        // Logo (if you have one)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.tintColor = .white
        
        // Add fade-in animation
        logoImageView.alpha = 0
        appNameLabel.alpha = 0
        
        UIView.animate(withDuration: 1.0) {
            self.logoImageView.alpha = 1
            self.appNameLabel.alpha = 1
        }
    }
    
    private func navigateToHome() {
        print("Navigating to Home Screen...")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        print("Attempting to instantiate HomeViewController...")
        
        if let homeVC = storyboard.instantiateViewController(
            withIdentifier: Constants.StoryboardIDs.homeViewController) as? HomeViewController {
            
            print("HomeViewController instantiated successfully")
            
            // DEPENDENCY INJECTION
           
            let weatherService = WeatherService()
            
            print("Creating UserDefaultsStorageService...")
            let storageService = UserDefaultsStorageService()
            
            print("Creating HomeViewModel with services...")
            let viewModel = HomeViewModel(
                weatherService: weatherService,
                storageService: storageService
            )
            
            print("Injecting ViewModel into HomeViewController...")
            homeVC.viewModel = viewModel
            
            print("ViewModel injection complete!")
            
            // Set as root view controller with animation
            if let window = view.window {
                print("Setting HomeViewController as root...")
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = UINavigationController(rootViewController: homeVC)
                })
                print("Navigation complete!")
            }
        } else {
            print(" Could not instantiate HomeViewController!")
        }
    }
    
    
}
