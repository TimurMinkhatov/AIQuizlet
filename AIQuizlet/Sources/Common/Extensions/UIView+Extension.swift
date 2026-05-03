//
//  UIView+Extension.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 02.05.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func applyGradient(
        colors: [UIColor],
        startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
        endPoint: CGPoint = CGPoint(x: 1, y: 0.5),
        cornerRadius: CGFloat = 0
    ) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = cornerRadius
        
        layer.insertSublayer(gradient, at: 0)
    }
}
