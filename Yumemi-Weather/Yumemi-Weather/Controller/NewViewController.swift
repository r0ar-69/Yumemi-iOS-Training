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
        
        performSegue(withIdentifier: R.segue.newViewController.toMainViewController, sender: nil)
    }
}
