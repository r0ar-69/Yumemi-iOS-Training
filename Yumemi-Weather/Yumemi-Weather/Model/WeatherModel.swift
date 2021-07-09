//
//  WeatherModel.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import YumemiWeather

protocol WeatherModel: AnyObject {
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
        DispatchQueue.global().async {
            do {
                let request: String = try self.jsonParser.encode(from: Request(area: "tokyo", date: self.date))
                let weather: String = try YumemiWeather.syncFetchWeather(request)
                let weatherData: Response = try self.jsonParser.decode(from: weather)
                
                completion(.success(weatherData))
            } catch let error as YumemiWeatherError {
                completion(.failure(WeatherError(error: error)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

enum WeatherError: Error {
    case invalidParameterError
    case unknownError
    
    init(error: YumemiWeatherError) {
        switch error {
        case .invalidParameterError:
            self = .invalidParameterError
        case .unknownError:
            self = .unknownError
        }
    }
}
