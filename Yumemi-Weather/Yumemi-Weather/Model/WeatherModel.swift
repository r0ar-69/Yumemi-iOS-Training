//
//  WeatherModel.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import YumemiWeather

class WeatherModel {
    static let notificationName = "WeatherModelChanged"
    let notificationCenter = NotificationCenter()
    
    var weather: String = "" {
        didSet {
            notificationCenter.post(
                name: .init(rawValue: WeatherModel.notificationName),
                object: weather
            )
        }
    }
    
    func fetchWeather() {
        weather = YumemiWeather.fetchWeather()
    }
}
