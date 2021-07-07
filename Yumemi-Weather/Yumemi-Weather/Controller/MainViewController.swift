//
//  ViewController.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/01.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet var weatherView: WeatherView!
    private (set) var weatherModel: WeatherModel = WeatherModelImpl()
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        weatherView.activityIndicatorView.startAnimating()
        weatherModel.fetchWeather { result in
            DispatchQueue.main.async {
                self.weatherView.activityIndicatorView.stopAnimating()
                self.handleWeatherChange(result: result)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.viewWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification) {
        weatherView.activityIndicatorView.startAnimating()
        weatherModel.fetchWeather { result in
            DispatchQueue.main.async {
                self.weatherView.activityIndicatorView.stopAnimating()
                self.handleWeatherChange(result: result)
            }
        }
    }
    
    func handleWeatherChange(result: Result<Response, Error>) {
        switch result {
        case .success(let responce):
            weatherView.set(response: responce)
        case .failure(let error):
            handleErrorOccurred(error: error)
        }
    }
    
    func handleErrorOccurred(error: Error) {
        var message: String
        
        switch error {
        case let error as WeatherError:
            switch error {
            case .invalidParameterError:
                message = "Yumemi Weather Error\n'Invalid Parameter'"
            case .unknownError:
                message = "Yumemi Weather Error\n'Unknown'"
            }
        case let error as JsonError:
            switch error {
            case .decodeError:
                message = "Json Error\n'Decode'"
            case .encodeError:
                message = "Json Error\n'Encode'"
            case .convertError:
                message = "Json Error\n'Convert'"
            }
        default:
            message = "Unknown Error Occurred"
        }
        
        let alertController: UIAlertController = UIAlertController(
            title:"Error",
            message: message,
            preferredStyle: .alert
        )
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "Close",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
