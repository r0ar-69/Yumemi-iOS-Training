//
//  WeatherView.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import UIKit
import Rswift

class WeatherView: UIView {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    public func set(weather: Dictionary<String, Any>) {
        switch weather["weather"] as! String {
        case "sunny":
            weatherImageView.image = R.image.sunny()
            weatherImageView.tintColor = R.color.sun()
        case "cloudy":
            weatherImageView.image = R.image.cloudy()
            weatherImageView.tintColor = R.color.cloud()
        case "rainy":
            weatherImageView.image = R.image.rainy()
            weatherImageView.tintColor = R.color.umbrella()
        default:
            break
        }
        
        let minTemp: Int = weather["min_temp"] as! Int
        let maxTemp: Int = weather["max_temp"] as! Int
        
        minTempLabel.text = String(minTemp)
        maxTempLabel.text = String(maxTemp)
    }
}
