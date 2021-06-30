//
//  JsonParseTests.swift
//  Yumemi-WeatherTests
//
//  Created by 清浦 駿 on 2021/06/30.
//

import XCTest
@testable import Yumemi_Weather

class JsonParseTests: XCTestCase {
    
    var jsonPerser: JsonParserMock!
    
    override func setUp() {
        jsonPerser = JsonParserMock()
    }
    
    func test_Jsonのエンコード() throws {
        let expectedResult = """
{"date":"","area":""}
"""
        let result = try jsonPerser.request(from: Request(area: "", date: ""))
        
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

class JsonParserMock: JsonParser {
    func request<T>(from value: T) throws -> String where T : Encodable {
        let encoder = JSONEncoder()
        let encodedDate = try encoder.encode(value)
        
        return String(data: encodedDate, encoding: .utf8)!
    }
    
    func decode<T>(from value: String) throws -> T where T : Decodable {
        let jsonData: Data = value.data(using: .utf8)!
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedData = try jsonDecoder.decode(T.self, from: jsonData)
        
        return decodedData
    }
}
