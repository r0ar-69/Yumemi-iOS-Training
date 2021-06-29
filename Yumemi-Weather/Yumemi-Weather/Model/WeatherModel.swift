//
//  WeatherModel.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import YumemiWeather

final class WeatherModelImpl: WeatherModel {
    private let date: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }()
    
    func fetchWeather(completion:(Result<Response, Error>) -> Void) {
        do {
            let request = try request(from: Request(area: "tokyo", date: date))
            let weather = try YumemiWeather.fetchWeather(request)
            let weatherData: Response = try decode(from: weather)
            
            completion(.success(weatherData))
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

public enum WeatherError: Error {
    case invalidParameterError
    case unknownError
}
