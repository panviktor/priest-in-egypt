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


class MenuViewController: UIViewController {
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
       
      
    }
    
    @IBAction func unwind( _ segue: UIStoryboardSegue) {
    }
}


