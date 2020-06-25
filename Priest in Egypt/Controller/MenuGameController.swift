//
//  MenuGameController.swift
//  Priest in Egypt
//
//  Created by Viktor on 24.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class MenuViewController: UIViewController, BlurViewControllerDelegate {
    lazy var backgroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "Mining by Moonlight", withExtension: "mp3") else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
    }()
    
    private var musicStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic()
    }
    
    private func playMusic() {
        DispatchQueue.main.async {
            self.backgroundMusic?.play()
        }
    }
    
    @IBAction func musicToggle() {
        musicStatus.toggle()
        musicStatus == true ? playMusic() : backgroundMusic?.stop()
    }
    
    @IBAction func topScore() {
        let blurVC = ScoreViewController()
        blurVC.modalPresentationStyle = .custom
        present(blurVC, animated: true, completion: nil)
        setBlurView()
        blurVC.delegate = self
    }
    
    func setBlurView() {
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .extraLight)
        view.addSubview(blurView)
    }
    
    func removeBlurView() {
        for subview in view.subviews {
            if subview.isKind(of: UIVisualEffectView.self) {
                subview.removeFromSuperview()
            }
        }
    }
    
    @IBAction func unwind( _ segue: UIStoryboardSegue) {}
}


