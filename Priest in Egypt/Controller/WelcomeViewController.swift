//
//  ViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 24.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func launchTheGame() {
        let sb = UIStoryboard(name: "Game", bundle: .main)
        let navigationVC = sb.instantiateInitialViewController() ?? UIViewController()
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true, completion: nil)
    }
}

