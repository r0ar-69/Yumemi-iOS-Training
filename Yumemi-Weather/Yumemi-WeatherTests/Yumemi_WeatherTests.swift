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
    
    func test_天気が晴れの時WeatherImageViewに晴れの画像が設定される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "sunny")
        weatherModel.fetchWeather(){ result in
            mainViewController.handleWeatherChange(result: result)
        }
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.sun())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.sunny())
    }
    
    func test_天気が曇りの時WeatherImageViewに曇りの画像が設定される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "cloudy")
        weatherModel.fetchWeather(){ result in
            mainViewController.handleWeatherChange(result: result)
        }
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.cloud())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.cloudy())
    }
    
    func test天気が雨の時にWeatherImageViewに雨の画像が設定される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "rainy")
        weatherModel.fetchWeather(){ result in
            mainViewController.handleWeatherChange(result: result)
        }
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.umbrella())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.rainy())
    }
    
    func test_気温がUILabelに設定される() throws {
        weatherModel.response = Response(maxTemp: 10, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "rainy")
        weatherModel.fetchWeather(){ result in
            mainViewController.handleWeatherChange(result: result)
        }
        XCTAssertEqual(mainViewController.weatherView.maxTempLabel.text, "10")
        XCTAssertEqual(mainViewController.weatherView.minTempLabel.text, "0")
    }
    
    func test_Jsonのエンコード() throws {
        let expectedResult = """
{"date":"","area":""}
"""
        let request = Request(area: "", date: "")
        let encoder = JSONEncoder()
        let encodedDate = try encoder.encode(request)
        let result = String(data: encodedDate, encoding: .utf8)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_Jsonのデコード() throws {
        let expectedResult = Response(maxTemp: 0, minTemp: 0, date: "", weather: "")
        let jsonString = """
{"max_temp":0,"min_temp":0,"date":"","weather":""}
"""
        let jsonData: Data = jsonString.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try jsonDecoder.decode(Response.self, from: jsonData)
        
        XCTAssertEqual(result.maxTemp, expectedResult.maxTemp)
        XCTAssertEqual(result.minTemp, expectedResult.minTemp)
        XCTAssertEqual(result.date, expectedResult.date)
        XCTAssertEqual(result.weather, expectedResult.weather)
    }

}

class WeatherModelMock: WeatherModel {
    var response: Response = Response(maxTemp: 0, minTemp: 0, date: "", weather: "")
    
    func fetchWeather(completion: (Result<Response, Error>) -> Void) {
        completion(.success(response))
    }
}
