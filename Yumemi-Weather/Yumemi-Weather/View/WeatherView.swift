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
    
    public func set(weather: String) {
        switch weather {
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
    }
    
    public func setAlertWith(error: String) -> UIAlertController {
        let alertController: UIAlertController = UIAlertController(
            title:"Error",
            message: error,
            preferredStyle: .alert
        )
        
        let defaultAction:UIAlertAction = UIAlertAction(
            title: "Close",
            style: .default,
            handler:{(action:UIAlertAction!) -> Void in
            }
        )
        
        alertController.addAction(defaultAction)
        
        return alertController
    }
}
