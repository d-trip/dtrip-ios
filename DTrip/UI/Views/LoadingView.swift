//
//  LoadingView.swift
//  DTrip
//
//  Created by Artem Semavin on 27/11/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit

final class LoadingView: UIView {
    
    private var animateLayer: CALayer = CALayer()
    private var isActive: Bool = false
    private var hasSuperView: Bool = false
    var sizeAnimation = CGSize(width: Spaces.septuple, height: Spaces.septuple)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDefault()
    }
    
    private func setupDefault() {
        backgroundColor = UIColor.white.withAlphaComponent(0.6)
        alpha = 0
    }
    
    func startAnimation(animate: Bool = true) {
        guard isActive == false else { return }
        
        setUpAnimation(in: layer, size: sizeAnimation, color: .blue)
        if animate {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1
            }
        } else {
            alpha = 1
        }
        isActive = true
    }
    
    func startAnimation(for view: UIView, animate: Bool = true, insets: UIEdgeInsets = .zero) {
        guard isActive == false else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        hasSuperView = true
        frame = view.bounds
        
        view.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right),
        ])
        startAnimation(animate: animate)
    }
    
    func stopAnimation(animate: Bool = true) {
        guard isActive else { return }
        
        if animate {
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 0
            }) { _ in
                self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                if self.hasSuperView {
                    self.removeFromSuperview()
                    self.hasSuperView.toggle()
                }
            }
        } else {
            alpha = 0
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            if hasSuperView {
                removeFromSuperview()
                hasSuperView.toggle()
            }
        }
        isActive = false
    }
    
    func updateViewCenter(_ point: CGPoint) {
        animateLayer.position = point
    }
    
    private func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 1.2
        let strokeEndDuration: Double = 0.7
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        
        animateLayer = makeLayer(size: size, color: color)
        let frame = CGRect(
            x: (layer.bounds.width - size.width) / 2,
            y: (layer.bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        
        animateLayer.frame = frame
        animateLayer.add(groupAnimation, forKey: "animation")
        layer.addSublayer(animateLayer)
    }
    
    private func makeLayer(size: CGSize, color: UIColor) -> CALayer {
        let layer = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        let lineWidth: CGFloat = 2
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        path.addArc(withCenter: center,
                    radius: size.width / 2,
                    startAngle: -(.pi / 2),
                    endAngle: .pi + .pi / 2,
                    clockwise: true)
        
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        layer.backgroundColor = nil
        
        layer.lineWidth = lineWidth
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
}
