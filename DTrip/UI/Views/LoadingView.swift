//
//  LoadingView.swift
//  DTrip
//
//  Created by Artem Semavin on 27/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    private var isActive: Bool = false
    
    func startAnimation() {
        guard isActive == false else { return }
        let size = CGSize(width: 64, height: 64)
        setUpAnimation(in: layer, size: size, color: .blue)
        isActive = true
    }
    
    func stopAnimation() {
        guard isActive else { return }
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        isActive = false
    }
    
    private func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let duration: CFTimeInterval = 1
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.21, 0.53, 0.56, 0.8)
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.7]
        scaleAnimation.timingFunction = timingFunction
        scaleAnimation.values = [0.1, 1]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimation.keyTimes = [0, 0.7, 1]
        opacityAnimation.timingFunctions = [timingFunction, timingFunction]
        opacityAnimation.values = [1, 0.7, 0]
        opacityAnimation.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimation]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        // Draw circle
        let circle = makeLayer(size: size, color: color)
        let frame = CGRect(x: (layer.bounds.size.width - size.width) / 2,
                           y: (layer.bounds.size.height - size.height) / 2,
                           width: size.width,
                           height: size.height)
        
        circle.frame = frame
        circle.add(animation, forKey: "animation")
        layer.addSublayer(circle)
    }
    
    private func makeLayer(size: CGSize, color: UIColor) -> CALayer {
        let path = UIBezierPath()
        let point = CGPoint(x: size.width / 2, y: size.height / 2)
        
        path.addArc(withCenter: point,
                    radius: size.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: false)

        let layer: CAShapeLayer = CAShapeLayer()
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.backgroundColor = nil
        layer.lineWidth = 2
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
}
