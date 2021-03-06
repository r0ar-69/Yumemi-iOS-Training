//
//  WeatherView.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/02.
//

import Foundation
import UIKit

final class WeatherView: UIView {
    
    @IBOutlet private (set) weak var weatherImageView: UIImageView!
    @IBOutlet private (set) weak var minTempLabel: UILabel!
    @IBOutlet private (set) weak var maxTempLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    func set(response: Response) {
        switch response.weather {
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
        
        minTempLabel.text = String(response.minTemp)
        maxTempLabel.text = String(response.maxTemp)
    }
    
    func activityIndicatorViewStartAnimating() {
        activityIndicatorView.startAnimating()
    }
    
    func activityIndicatorViewStopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
