//
//  WeatherModel.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import YumemiWeather

protocol  WeatherModel: AnyObject {
    func fetchWeather() -> (Result<Response, Error>)
}

protocol JsonParser: AnyObject {
    func request<T: Encodable>(from value: T) throws -> String
    func decode<T: Decodable>(from value: String) throws -> T
}

final class WeatherModelImpl: WeatherModel, JsonParser {
    private let date: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }()
    
    func fetchWeather() -> (Result<Response, Error>) {
        do {
            let request = try request(from: Request(area: "tokyo", date: date))
            let weather = try YumemiWeather.fetchWeather(request)
            let weatherData: Response = try decode(from: weather)
            
            return .success(weatherData)
        } catch {
            switch error {
            case YumemiWeatherError.invalidParameterError:
                let err = WeatherError.invalidParameterError
                return .failure(err)
            case YumemiWeatherError.unknownError:
                let err = WeatherError.unknownError
                return .failure(err)
            default:
                return .failure(error)
            }
        }
    }
    
    func request<T>(from value: T) throws -> String where T : Encodable {
        let encoder = JSONEncoder()
        guard let encodedDate = try? encoder.encode(value),
              let jsonString = String(data: encodedDate, encoding: .utf8) else {
            throw JsonError.encodeError
        }
        
        return jsonString
    }
    
    func decode<T>(from value: String) throws -> T where T : Decodable {
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
