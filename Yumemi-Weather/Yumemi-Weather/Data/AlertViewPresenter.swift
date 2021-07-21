//
//  AlertViewPresenter.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/07/21.
//

import UIKit

final class AlertViewPresenterImpl : AlertViewPresenter {
    func present(title: String, message: String, presentingViewController: UIViewController) {
        let alertController: UIAlertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "Close",
            style: .default
        )
        
        alertController.addAction(defaultAction)
        presentingViewController.present(alertController, animated: true)
    }
}
