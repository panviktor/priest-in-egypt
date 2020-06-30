//
//  ViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 24.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var playButton: UIButton!
    @IBOutlet var mainBackgroundView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.pulsate(_repeatCount: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func launchTheGame() {
        let sb = UIStoryboard(name: "Game", bundle: .main)
        let navigationVC = sb.instantiateInitialViewController() ?? UIViewController()
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true, completion: nil)
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        self.launchTheGame()
    }
    
    override var prefersStatusBarHidden: Bool {

        return true

    } 
}

