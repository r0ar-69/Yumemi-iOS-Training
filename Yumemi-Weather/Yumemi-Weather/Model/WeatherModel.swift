//
//  WeatherModel.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import YumemiWeather

class WeatherModel {
    let notificationCenter = NotificationCenter()
    
    func fetchWeather() {
        do {
            let weather = try YumemiWeather.fetchWeather(at: "tokyo")
            
            notificationCenter.post(
                name: .weatherModelChanged,
                object: weather
            )
        } catch YumemiWeatherError.invalidParameterError {
            notificationCenter.post(
                name: .errorOccurred,
                object: "Invalid Parameter"
            )
        } catch YumemiWeatherError.unknownError {
            notificationCenter.post(
                name: .errorOccurred,
                object: "Unknown"
            )
        } catch {
            
        }
    }
}

extension Notification.Name {
    static let weatherModelChanged = Notification.Name("WeatherModelChanged")
    static let errorOccurred = Notification.Name("ErrorOccurred")
}
