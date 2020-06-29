//
//  ScoreViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 25.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

protocol BlurViewDelegate: class {
    func removeBlurView()
}

class ScoreViewController: UIViewController {
    @IBOutlet var images: UIImageView!
    @IBOutlet var firstScore: UILabel!
    @IBOutlet var secondScore: UILabel!
    @IBOutlet var thirdScore: UILabel!
    @IBOutlet var tapView: UIView!
    
    let scoreManager = ScoreManager()
    weak var delegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss(_:)))
        tapView.addGestureRecognizer(tapToDismiss)
    }
    
    @IBAction func resetScore() {
        scoreManager.reset()
        delegate?.removeBlurView()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tapToDismiss(_ recognizer: UITapGestureRecognizer) {
        delegate?.removeBlurView()
        dismiss(animated: true, completion: nil)
    }
    
    private func setLabel() {
        firstScore.text = "\(scoreManager.firstScore)"
        secondScore.text = "\(scoreManager.secondScore)"
        thirdScore.text = "\(scoreManager.thirdScore)"
    }
}


