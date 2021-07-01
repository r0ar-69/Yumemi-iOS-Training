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

final class WeatherModelImpl: WeatherModel {
    let jsonParser = JsonParser()
    
    private let date: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }()
    
    func fetchWeather() -> (Result<Response, Error>) {
        do {
            let request = try jsonParser.request(from: Request(area: "tokyo", date: date))
            let weather = try YumemiWeather.fetchWeather(request)
            let weatherData: Response = try jsonParser.decode(from: weather)
            
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
    

}

enum WeatherError: Error {
    case invalidParameterError
    case unknownError
}
