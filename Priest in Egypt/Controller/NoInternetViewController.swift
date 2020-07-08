//
//  NoInternetViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 29.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import Lottie

class NoInternetViewController: UIViewController {
    let service = DifferentServices.shared
    let animationView = AnimationView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLoadingView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimating()
    }
    
    fileprivate func setupLoadingView() {
        let animation = Animation.named("no-internet-connection")
        
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
                           loopMode: LottieLoopMode.loop)
    }
}

