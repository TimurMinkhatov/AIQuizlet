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
    private let key = "selectedTheme"
    private init() {}
    
    var savedStyle: UIUserInterfaceStyle {
        let raw = UserDefaults.standard.integer(forKey: key)
        return UIUserInterfaceStyle(rawValue: raw) ?? .unspecified
    }
    
    func apply(style: UIUserInterfaceStyle) {
        UserDefaults.standard.set(style.rawValue, forKey: key)
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
