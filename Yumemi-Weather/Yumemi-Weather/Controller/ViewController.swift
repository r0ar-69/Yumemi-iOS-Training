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
            name: .init(NSNotification.Name(rawValue: WeatherModel.notificationName)),
            object: nil
        )
    }

    @objc func handleWeatherChange(_ notification: Notification) {
        if let weather = notification.object as? String {
            weatherView.set(weather: weather)
        }
    }

}
