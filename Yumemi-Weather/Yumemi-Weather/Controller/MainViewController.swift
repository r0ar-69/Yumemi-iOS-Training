//
//  ViewController.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/01.
//

import UIKit

protocol AlertViewPresenter: AnyObject {
    func present(title: String, message: String, presentingViewController: UIViewController)
}

final class MainViewController: UIViewController {
    
    @IBOutlet var weatherView: WeatherView!
    private (set) var weatherModel: WeatherModel = WeatherModelImpl()
    var alertView: AlertViewPresenter = AlertViewPresenterImpl()
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func reloadButton(_ sender: Any) {
        reloadWeather()
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
    
    deinit {
        print("deinit called")
    }
    
    @objc func viewWillEnterForeground(_ notification: Notification) {
        reloadWeather()
    }
    
    func reloadWeather() {
        weatherView.activityIndicatorViewStartAnimating()
        weatherModel.fetchWeather(onSuccess: {response in
            DispatchQueue.main.async { [weak self] in
                self?.weatherView.activityIndicatorViewStopAnimating()
                self?.weatherView.set(response: response)
            }
        }, onError: { [weak self] error in
            DispatchQueue.main.async {
                self?.weatherView.activityIndicatorViewStopAnimating()
                self?.handleErrorOccurred(error: error)
            }
        })
    }
    
    func handleErrorOccurred(error: Error) {
        let message = makeErrorMessage(from: error)
        
        alertView.present(title: "Error", message: message, presentingViewController: self)
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

final class AlertViewPresenterImpl : AlertViewPresenter {
    func present(title: String, message: String, presentingViewController: UIViewController) {
        let alertController: UIAlertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "Close",
            style: .default,
            handler: nil
        )
        
        alertController.addAction(defaultAction)
        presentingViewController.present(alertController, animated: true)
    }
}
