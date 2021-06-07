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
            let weather = try YumemiWeather.fetchWeather("""
                {
                    "area" : "tokyo",
                    "date" : "2020-04-01T12:00:00+09:00"
                }
            """)
            
            guard let weatherData: Response = try? decode(weather: weather) else {
                throw ResponseError.jsonDecodeError
            }
            
            notificationCenter.post(
                name: .weatherModelChanged,
                object: weatherData
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
            case ResponseError.jsonDecodeError:
                notificationCenter.post(
                    name: .errorOccurred,
                    object: "Response Error\n'JSON Decode'"
                )
            case ResponseError.unknownError:
                notificationCenter.post(
                    name: .errorOccurred,
                    object: "Response Error\n'Unknown'"
                )
            default:
                notificationCenter.post(
                    name: .errorOccurred,
                    object: "Unknown Error Occurred"
                )
            }
        }
    }
    
    func decode(weather: String) throws -> Response {
        let jsonData = weather.data(using: .utf8)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let response = try jsonDecoder.decode(Response.self, from: jsonData!)
        
        return response
    }
}

extension Notification.Name {
    static let weatherModelChanged = Notification.Name("WeatherModelChanged")
    static let errorOccurred = Notification.Name("ErrorOccurred")
}
