//
//  Yumemi_WeatherTests.swift
//  Yumemi-WeatherTests
//
//  Created by 清浦 駿 on 2021/06/01.
//

import XCTest
@testable import Yumemi_Weather

class Yumemi_WeatherTests: XCTestCase {
    
    var mainViewController: MainViewController!
    var weatherModel: WeatherModelMock!
    var weatherView: WeatherView!

    override func setUpWithError() throws {
        weatherModel = WeatherModelMock()
        mainViewController = R.storyboard.main.mainViewController()!
        mainViewController.weatherModel = weatherModel
        _ = mainViewController.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_天気が晴れの時WeatherImageViewに晴れの画像が表示される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "sunny")
        mainViewController.reloadButton(UIButton())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.sun())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.sunny())
    }
    
    func test_天気が曇りの時WeatherImageViewに曇りの画像が表示される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "cloudy")
        mainViewController.reloadButton(UIButton())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.cloud())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.cloudy())
    }
    
    func test天気が雨の時にWeatherImageViewに雨の画像が表示される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "rainy")
        mainViewController.reloadButton(UIButton())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.umbrella())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.rainy())
    }
    
    func test_気温がUILabelに表示されるかのテスト() throws {
        weatherModel.response = Response(maxTemp: 10, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "rainy")
        mainViewController.reloadButton(UIButton())
        XCTAssertEqual(mainViewController.weatherView.maxTempLabel.text, "10")
        XCTAssertEqual(mainViewController.weatherView.minTempLabel.text, "0")
    }
    
    func test_Jsonのエンコード() throws {
        let jsonString = """
{"date":"","area":""}
"""
        let request = Request(area: "", date: "")
        let result = try weatherModel.request(from: request)
        
        XCTAssertEqual(result, jsonString)
    }
    
    func test_Jsonのデコード() throws {
        let jsonString = """
{"max_temp":0,"min_temp":0,"date":"","weather":""}
"""
        let response = Response(maxTemp: 0, minTemp: 0, date: "", weather: "")
        let result: Response = try weatherModel.decode(from: jsonString)
        
        XCTAssertEqual(response.maxTemp, result.maxTemp)
        XCTAssertEqual(response.minTemp, result.minTemp)
        XCTAssertEqual(response.date, result.date)
        XCTAssertEqual(response.weather, result.weather)
    }

}

class WeatherModelMock: WeatherModel {
    var response: Response = Response(maxTemp: 0, minTemp: 0, date: "", weather: "")
    
    func fetchWeather(completion: @escaping (Result<Response, Error>) -> Void) {
        completion(.success(response))
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
