//
//  Extension+UIButton.swift
//  Priest in Egypt
//
//  Created by Viktor on 25.06.2020.
//  Copyright © 2020 Viktor. All rights reserved.
//

import UIKit

extension UIButton {
    
    func pulsate(_repeatCount: Int) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.90
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 5
        pulse.initialVelocity = 0.45
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        
        layer.add(flash, forKey: nil)
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
    }
    
    func rotate() {
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 0.5
        fullRotation.repeatCount = 1
        layer.add(fullRotation, forKey: "360")
    }
}

