//
//  JsonParseTests.swift
//  Yumemi-WeatherTests
//
//  Created by 清浦 駿 on 2021/06/30.
//

import XCTest
@testable import Yumemi_Weather

final class JsonParserTests: XCTestCase {
    
    let jsonPerser = JsonParser()
    
    func test_Jsonのエンコード() throws {
        let expectedResult = """
{"date":"","area":""}
"""
        let result = try jsonPerser.encode(from: Request(area: "", date: ""))
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_Jsonのデコード() throws {
        let expectedResult = Response(maxTemp: 0, minTemp: 0, date: "", weather: "")
        let jsonString = """
{"max_temp":0,"min_temp":0,"date":"","weather":""}
"""
        let result: Response = try jsonPerser.decode(from: jsonString)
        
        XCTAssertEqual(result.maxTemp, expectedResult.maxTemp)
        XCTAssertEqual(result.minTemp, expectedResult.minTemp)
        XCTAssertEqual(result.date, expectedResult.date)
        XCTAssertEqual(result.weather, expectedResult.weather)
    }
}
