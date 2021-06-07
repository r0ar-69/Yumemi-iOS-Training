//
//  ViewController.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/01.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var weatherView: WeatherView!
    private var weatherModel = WeatherModel()
    
    @IBAction func closeButton(_ sender: Any) {
    }
    @IBAction func reloadButton(_ sender: Any) {
        weatherModel.fetchWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc func handleWeatherChange(_ notification: Notification) {
        if let weather = notification.object as? String {
            weatherView.set(weather: weather)
        }
    }
    
    @objc func handleErrorOccurred(_ notification: Notification) {
        if let error = notification.object as? String {
            present(weatherView.setAlertWith(error: error), animated: true, completion: nil)
        }
    }

}
