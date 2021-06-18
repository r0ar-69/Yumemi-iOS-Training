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
            let request = try request(from: Request(area: "tokyo", date: date))
            let weather = try YumemiWeather.fetchWeather(request)
            let weatherData: Response = try decode(from: weather)
            
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
                case .convertError:
                    notificationCenter.post(
                        name: .errorOccurred,
                        object: "Json Error\n'Convert'"
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
    
    private func request<T: Encodable>(from value: T) throws -> String {
        let encoder = JSONEncoder()
        guard let encodedDate = try? encoder.encode(value),
              let jsonString = String(data: encodedDate, encoding: .utf8) else {
            throw JsonError.encodeError
        }
        
        return jsonString
    }
    
    private func decode<T: Decodable>(from value: String) throws -> T {
        guard let jsonData: Data = value.data(using: .utf8) else {
            throw JsonError.convertError
        }
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let response = try? jsonDecoder.decode(T.self, from: jsonData) else {
            throw JsonError.decodeError
        }
        
        return response
    }
}

extension Notification.Name {
    static let weatherModelChanged = Notification.Name("WeatherModelChanged")
    static let errorOccurred = Notification.Name("ErrorOccurred")
}
