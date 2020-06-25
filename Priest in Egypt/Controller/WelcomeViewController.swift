//
//  ViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 24.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import Lottie

class WelcomeViewController: UIViewController {
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimating()
    }
    
    private func launchTheGame() {
        let sb = UIStoryboard(name: "Game", bundle: .main)
        let navigationVC = sb.instantiateInitialViewController() ?? UIViewController()
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true, completion: nil)
    }
    
    fileprivate func setupLoadingView() {
        let animation = Animation.named("987-estimate")
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        view.addSubview(animationView)
        view.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        animationView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        animationView.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
    }
    
    fileprivate func startAnimating() {
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.repeat(2),
                           completion: { (finished) in
                            if finished {
                                print("Animation Complete")
                                self.launchTheGame()
                            } else {
                                print("Animation cancelled")
                            }
        })
    }
    
    fileprivate func checkBOT() {
        
    }
}

