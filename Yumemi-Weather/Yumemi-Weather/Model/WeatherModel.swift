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
        } catch {
            switch error {
            case YumemiWeatherError.invalidParameterError:
                notificationCenter.post(
                    name: .errorOccurred,
                    object: "Yumemi Weather Error\n'Invalid Parameter'"
                )
            case YumemiWeatherError.unknownError:
                notificationCenter.post(
                    name: .errorOccurred,
                    object: "Yumemi Weather Error\n'Unknown'"
                )
            default:
                notificationCenter.post(
                    name: .errorOccurred,
                    object: "Unknown Error Occurred"
                )
            }
        }
    }
}

extension Notification.Name {
    static let weatherModelChanged = Notification.Name("WeatherModelChanged")
    static let errorOccurred = Notification.Name("ErrorOccurred")
}
