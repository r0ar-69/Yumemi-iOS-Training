//
//  Yumemi_WeatherTests.swift
//  Yumemi-WeatherTests
//
//  Created by 清浦 駿 on 2021/06/01.
//

import XCTest
@testable import Yumemi_Weather

final class Yumemi_WeatherTests: XCTestCase {
    
    var mainViewController: MainViewController!
    var weatherModel: WeatherModelMock!
    var weatherView: WeatherView!
    
    override func setUpWithError() throws {
        weatherModel = WeatherModelMock()
        mainViewController = R.storyboard.main.mainViewController()!
        _ = mainViewController.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_天気が晴れの時WeatherImageViewに晴れの画像が設定される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "sunny")
        weatherModel.fetchWeather(onSuccess: { response in
            self.mainViewController.weatherView.set(response: response)
            XCTAssertEqual(self.mainViewController.weatherView.weatherImageView.tintColor, R.color.sun())
            XCTAssertEqual(self.mainViewController.weatherView.weatherImageView.image, R.image.sunny())
        }, onError: nil)
    }
    
    func test_天気が曇りの時WeatherImageViewに曇りの画像が設定される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "cloudy")
        weatherModel.fetchWeather(onSuccess: { response in
            self.mainViewController.weatherView.set(response: response)
            XCTAssertEqual(self.mainViewController.weatherView.weatherImageView.tintColor, R.color.cloud())
            XCTAssertEqual(self.mainViewController.weatherView.weatherImageView.image, R.image.cloudy())
        }, onError: nil)
    }
    
    func test天気が雨の時にWeatherImageViewに雨の画像が設定される() throws {
        weatherModel.response = Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "rainy")
        weatherModel.fetchWeather(onSuccess: { response in
            self.mainViewController.weatherView.set(response: response)
            XCTAssertEqual(self.mainViewController.weatherView.weatherImageView.tintColor, R.color.umbrella())
            XCTAssertEqual(self.mainViewController.weatherView.weatherImageView.image, R.image.rainy())
        }, onError: nil)
    }
    
    func test_気温がUILabelに設定される() throws {
        weatherModel.response = Response(maxTemp: 10, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "rainy")
        weatherModel.fetchWeather(onSuccess: { response in
            self.mainViewController.weatherView.set(response: response)
            XCTAssertEqual(self.mainViewController.weatherView.maxTempLabel.text, "10")
            XCTAssertEqual(self.mainViewController.weatherView.minTempLabel.text, "0")
        }, onError: nil)
    }
}

class WeatherModelMock: WeatherModel {
    var response: Response = Response(maxTemp: 0, minTemp: 0, date: "", weather: "")
    
    func fetchWeather(onSuccess: @escaping (Response) -> Void, onError: ((Error) -> Void)?) {
        onSuccess(response)
    }
}
