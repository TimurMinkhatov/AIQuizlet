//
//  ThemeManager.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 05/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import UIKit

final class ThemeManager {
    
    static let shared = ThemeManager()
    private init() {}
    
    func apply(style: UIUserInterfaceStyle) {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { $0.overrideUserInterfaceStyle = style }
        
        NotificationCenter.default.post(name: .themeDidChange, object: style)
    }
}

extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}
