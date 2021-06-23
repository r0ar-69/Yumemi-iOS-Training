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
    var weatherModel: WeatherModel!
    var weatherView: WeatherView!

    override func setUpWithError() throws {
        weatherModel = WeatherModel()
        mainViewController = R.storyboard.main.mainViewController()!
        mainViewController.weatherModel = weatherModel
        _ = mainViewController.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSetSunnyImageToWeatherImageViewWhenWeatherIsSunny() throws {
        weatherModel.notificationCenter.post(name: .weatherModelChanged, object: Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "sunny"))
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.sun())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.sunny())
    }
    
    func testSetCloudyImageToWeatherImageViewWhenWeatherIsCloudy() throws {
        weatherModel.notificationCenter.post(name: .weatherModelChanged, object: Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "cloudy"))
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.cloud())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.cloudy())
    }
    
    func testSetRainyImageToWeatherImageViewWhenWeatherIsRainy() throws {
        weatherModel.notificationCenter.post(name: .weatherModelChanged, object: Response(maxTemp: 0, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "rainy"))
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.tintColor, R.color.umbrella())
        XCTAssertEqual(mainViewController.weatherView.weatherImageView.image, R.image.rainy())
    }
    
    func testSetTempretureToUILabel() throws {
        weatherModel.notificationCenter.post(name: .weatherModelChanged, object: Response(maxTemp: 10, minTemp: 0, date: "2020-04-01T12:00:00+09:00", weather: "sunny"))
        XCTAssertEqual(mainViewController.weatherView.maxTempLabel.text, "10")
        XCTAssertEqual(mainViewController.weatherView.minTempLabel.text, "0")
    }
    
    func testJsonEncode() throws {
        let jsonString = """
{"date":"","area":""}
"""
        let request = Request(area: "", date: "")
        let result = try weatherModel.request(from: request)
        
        XCTAssertEqual(result, jsonString)
    }
    
    func testJsonDecode() throws {
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
