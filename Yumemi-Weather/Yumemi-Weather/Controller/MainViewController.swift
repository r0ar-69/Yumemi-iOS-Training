//
//  ViewController.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/01.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet var weatherView: WeatherView!
    private var weatherModel = WeatherModel()
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        weatherModel.fetchWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.viewWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        weatherModel.notificationCenter.addObserver(
            self,
            selector: #selector(self.handleWeatherChange(_:)),
            name: .weatherModelChanged,
            object: nil
        )
        weatherModel.notificationCenter.addObserver(
            self,
            selector: #selector(self.handleErrorOccurred(_:)),
            name: .errorOccurred,
            object: nil
        )
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification) {
        weatherModel.fetchWeather()
    }
    
    @objc func handleWeatherChange(_ notification: Notification) {
        if let weather = notification.object as? Response {
            weatherView.set(response: weather)
        }
    }
    
    @objc func handleErrorOccurred(_ notification: Notification) {
        if let error = notification.object as? String {
            let alertController: UIAlertController = UIAlertController(
                title:"Error",
                message: error,
                preferredStyle: .alert
            )
            
            let defaultAction: UIAlertAction = UIAlertAction(
                title: "Close",
                style: .default,
                handler: nil
            )
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
}
