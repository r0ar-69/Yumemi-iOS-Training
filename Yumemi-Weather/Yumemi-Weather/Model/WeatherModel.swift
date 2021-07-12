//
//  WeatherModel.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import YumemiWeather

protocol WeatherModel: AnyObject {
    func fetchWeather()
}

protocol WeatherModelDelegate: AnyObject {
    func fetchWeatherDidFinished(result: Result<Response, Error>)
}

final class WeatherModelImpl: WeatherModel {
    weak var delegate: WeatherModelDelegate?
    let jsonParser = JsonParser()
    
    private let date: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: Date())
        
        return dateString
    }()
    
    func fetchWeather() {
        DispatchQueue.global().async {
            do {
                let request: String = try self.jsonParser.encode(from: Request(area: "tokyo", date: self.date))
                let weather: String = try YumemiWeather.syncFetchWeather(request)
                let weatherData: Response = try self.jsonParser.decode(from: weather)
                
                self.delegate?.fetchWeatherDidFinished(result: .success(weatherData))
            } catch let error as YumemiWeatherError {
                self.delegate?.fetchWeatherDidFinished(result: .failure(WeatherError(error: error)))
            } catch {
                self.delegate?.fetchWeatherDidFinished(result: .failure(error))
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
