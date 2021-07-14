//
//  ViewController.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/01.
//

import UIKit

final class MainViewController: UIViewController{
    
    @IBOutlet var weatherView: WeatherView!
    private (set) var weatherModel: WeatherModel = WeatherModelImpl()
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        weatherView.activityIndicatorViewStartAnimating()
        weatherModel.fetchWeather()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherModel.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.viewWillEnterForeground(_:)),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    deinit {
        print("deinit called")
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification) {
        weatherView.activityIndicatorViewStartAnimating()
        weatherModel.fetchWeather()
    }
    
    func handleErrorOccurred(error: Error) {
        let message = makeErrorMessage(from: error)
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
    
    func makeErrorMessage(from error: Error) -> String {
        let message: String
        
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
        
        return message
    }
}

extension MainViewController: WeatherModelDelegate {
    func fetchWeatherDidSucceed(response: Response) {
        DispatchQueue.main.async {
            self.weatherView.activityIndicatorViewStopAnimating()
            self.weatherView.set(response: response)
        }
    }
    
    func fetchWeatherDidFail(error: Error) {
        DispatchQueue.main.async {
            self.weatherView.activityIndicatorViewStopAnimating()
            self.handleErrorOccurred(error: error)
        }
    }
}
