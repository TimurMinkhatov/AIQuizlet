//
//  UIColor+Hex.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 04/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//
import UIKit

enum AppColors {
    static let backgroundGradient: [UIColor] = [
        UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
        UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1),
        UIColor(red: 130/255, green: 0/255, blue: 219/255, alpha: 1)
    ]
    
    static let buttonGradient: [UIColor] = [
        UIColor(red: 21/255, green: 93/255, blue: 252/255, alpha: 1),
        UIColor(red: 152/255, green: 16/255, blue: 250/255, alpha: 1)
    ]
    
    static let correctBackground = UIColor(red: 13/255, green: 84/255, blue: 43/255, alpha: 0.3)
    static let wrongBackground = UIColor(red: 130/255, green: 24/255, blue: 26/255, alpha: 0.3)
    
    static let background = UIColor(named: "AppBackground")!
    static let cardBackground = UIColor(named: "CardBackground")!
    static let inactiveButton = UIColor(named: "InactiveButton")!
    static let tabBar = UIColor(named: "TabBar")!
    static let border = UIColor(named: "Border")!
    static let questionButtonInactive = UIColor(named: "QuestionButtonInactive")!
    static let explanationBackground = UIColor(named: "ExplanationBackground")!
}
