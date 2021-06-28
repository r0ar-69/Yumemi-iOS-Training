//
//  NewViewController.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/18.
//

import UIKit

final class NewViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewController = R.storyboard.main.mainViewController()!
        viewController.weatherModel = WeatherModelImpl()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
}
