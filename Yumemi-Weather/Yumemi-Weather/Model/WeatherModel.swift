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
    private let date: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }()
    
    func fetchWeather() {
        do {
            let jsonString = try requestFrom(area: "tokyo", date: date)
            let weather = try YumemiWeather.fetchWeather(jsonString)
            let weatherData = try decode(weather: weather)
            
            notificationCenter.post(
                name: .weatherModelChanged,
                object: weatherData
            )
        } catch {
            switch error {
            case let error as YumemiWeatherError:
                switch error {
                case .invalidParameterError:
                    notificationCenter.post(
                        name: .errorOccurred,
                        object: "Yumemi Weather Error\n'Invalid Parameter'"
                    )
                    
                case .unknownError:
                    notificationCenter.post(
                        name: .errorOccurred,
                        object: "Yumemi Weather Error\n'Unknown'"
                    )
                }
                
            case let error as JsonError:
                switch error {
                case .decodeError:
                    notificationCenter.post(
                        name: .errorOccurred,
                        object: "Json Error\n'Decode'"
                    )
                case .encodeError:
                    notificationCenter.post(
                        name: .errorOccurred,
                        object: "Json Error\n'Encode'"
                    )
                }
                
            default:
                notificationCenter.post(
                    name: .errorOccurred,
                    object: "Unknown Error Occurred"
                )
            }
        }
    }
    
    func requestFrom(area: String, date: String) throws -> String {
        let encoder = JSONEncoder()
        let request = Request(area: area, date: date)
        guard let encodedDate = try? encoder.encode(request) else {
            throw JsonError.encodeError
        }
        guard let jsonString = String(data: encodedDate, encoding: .utf8) else {
            throw JsonError.encodeError
        }
        
        return jsonString
    }
    
    func decode(weather: String) throws -> Response {
        guard let jsonData: Data = weather.data(using: .utf8) else {
            throw JsonError.decodeError
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let response = try? jsonDecoder.decode(Response.self, from: jsonData) else {
            throw JsonError.decodeError
        }
        
        return response
    }
}

extension Notification.Name {
    static let weatherModelChanged = Notification.Name("WeatherModelChanged")
    static let errorOccurred = Notification.Name("ErrorOccurred")
}
