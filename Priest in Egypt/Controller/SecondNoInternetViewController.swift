//
//  SecondNoInternetViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 08.07.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import Lottie

class SecondNoInternetViewController: UIViewController {
    let service = DifferentServices.shared
    @IBOutlet var animationView: AnimationView!
    
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
        animationView.backgroundColor = .clear
        animationView.animation = animation
        animationView.contentMode = .center
        animationView.backgroundBehavior = .pauseAndRestore
    }
    
    fileprivate func startAnimating() {
        animationView.play(fromProgress: 0,
                           toProgress: 1,
                           loopMode: LottieLoopMode.loop)
    }
    
}
