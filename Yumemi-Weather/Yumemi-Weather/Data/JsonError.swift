//
//  Error.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/07.
//

import Foundation

enum JsonError: Error {
    case decodeError
    case encodeError
    case unknownError
}
