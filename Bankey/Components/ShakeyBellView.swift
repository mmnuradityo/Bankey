//
//  ShakeyBellView.swift
//  Bankey
//
//  Created by Admin on 31/10/23.
//

import Foundation
import UIKit

class ShakeyBellView: UIView {
    
    let imageView = UIImageView()
    let frameSize: CGFloat = 48
    let contentSize: CGFloat = 24
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frameSize, height: frameSize)
    }
}

extension ShakeyBellView {
    
    func setup() {
        let singleTap = UITapGestureRecognizer(
            target: self, action: #selector(imageViewTapped(_: ))
        )
        imageView.addGestureRecognizer(singleTap)
        imageView.isUserInteractionEnabled = true
    }
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "bell.fill")!
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        imageView.image = image
    }
    
    func layout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: contentSize),
            imageView.widthAnchor.constraint(equalToConstant: contentSize)
        ])
    }
}


// MARK: ~ Actions
extension ShakeyBellView {
    
    @objc func imageViewTapped(_ recognizer: UITapGestureRecognizer) {
        shakeWith(duration: 1.0, angle: .pi/8, yOffset: 0.0)
    }
    
    private func shakeWith(duration: Double, angle: CGFloat, yOffset: CGFloat) {
        let numberOffFrame: Double = 6
        let frameDuration = Double(1/numberOffFrame)
        
        imageView.setAnchorPoint(CGPoint(x: 0.5, y: yOffset))
        
        UIView.animateKeyframes(
            withDuration: duration, delay: 0, options: [],
            animations: {
               
                var startTime: Double = 0.0
                var rotationAngle: CGAffineTransform
                
                let until = Int(numberOffFrame - 1)
                for i in 1...until {
                    if i > 0 {
                        startTime = i == 1 ? frameDuration : frameDuration * Double(i)
                    }
                    
                    rotationAngle = (i == until) ? CGAffineTransform.identity : CGAffineTransform(
                        rotationAngle: CGFloat((i % 2 == 0) ? -angle : +angle)
                    )
                    
                    self.addKeyFrame(
                        withRelativeStartTime: startTime, relativeDuration: frameDuration, rotationAngle: rotationAngle
                    )
                }
            },
            completion: nil
        )
    }
    
    private func addKeyFrame(withRelativeStartTime: Double, relativeDuration: Double, rotationAngle: CGAffineTransform) {
        UIView.addKeyframe(
            withRelativeStartTime: withRelativeStartTime,
            relativeDuration: relativeDuration,
            animations: {
                self.imageView.transform = rotationAngle
            }
        )
    }
    
}

// https://www.hackingwithswift.com/example-code/calayer/how-to-change-a-views-anchor-point-without-moving-it
extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
