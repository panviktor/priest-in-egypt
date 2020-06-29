//
//  WinViewController.swift
//  Priest in Egypt
//
//  Created by Viktor on 25.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit


class WinViewController: UIViewController {
    @IBOutlet var tapView: UIView!
    weak var delegate: BlurViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapToDismiss = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss(_:)))
        tapView.addGestureRecognizer(tapToDismiss)
    }
    
    
    @objc func tapToDismiss(_ recognizer: UITapGestureRecognizer) {
        delegate?.removeBlurView()
        dismiss(animated: true, completion: nil)
    }
}



