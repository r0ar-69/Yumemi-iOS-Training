//
//  WeatherModel.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import YumemiWeather

protocol  WeatherModel: AnyObject {
    func fetchWeather(completion: @escaping (Result<Response, Error>) -> Void)
}

final class WeatherModelImpl: WeatherModel {
    let jsonParser = JsonParser()
    
    private let date: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }()
    
    func fetchWeather(completion: @escaping (Result<Response, Error>) -> Void) {
        do {
            let request = try jsonParser.encode(from: Request(area: "tokyo", date: date))
            DispatchQueue.global().async {
                do {
                    let weather = try YumemiWeather.syncFetchWeather(request)
                    do {
                        let weatherData: Response = try self.jsonParser.decode(from: weather)
                            completion(.success(weatherData))
                    } catch {
                        completion(.failure(error))
                    }
                } catch {
                    switch error {
                    case YumemiWeatherError.invalidParameterError:
                        let err = WeatherError.invalidParameterError
                        completion(.failure(err))
                    case YumemiWeatherError.unknownError:
                        let err = WeatherError.unknownError
                        completion(.failure(err))
                    default:
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    
}

enum WeatherError: Error {
    case invalidParameterError
    case unknownError
}
