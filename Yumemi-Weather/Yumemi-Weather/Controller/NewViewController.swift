//
//  NewViewController.swift
//  Yumemi-Weather
//
//  Created by 清浦 駿 on 2021/06/18.
//

import UIKit

class NewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: R.segue.newViewController.toMainViewController.identifier, sender: nil)
    }
}
