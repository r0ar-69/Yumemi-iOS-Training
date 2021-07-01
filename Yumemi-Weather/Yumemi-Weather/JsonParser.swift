//
//  JsonParser.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/07/01.
//

import Foundation

class JsonParser {
    
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
