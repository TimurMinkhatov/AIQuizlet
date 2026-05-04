//
//  LocalizationService.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 02/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import Foundation

final class LocalizationService {

    // MARK: - Singleton

    static let shared = LocalizationService()

    // MARK: - Properties

    private let languageKey = "app_language"

    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: languageKey) ?? "ru"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: languageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: .languageDidChange, object: newValue)
        }
    }
    
    var bundle: Bundle {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return Bundle.main
        }
        return bundle
    }

    // MARK: - Init

    private init() {}

    // MARK: - Public Methods

    func localizedString(for key: String) -> String {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return NSLocalizedString(key, comment: "")
        }
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}

// MARK: - Notification

extension Notification.Name {
    static let languageDidChange = Notification.Name("languageDidChange")
}
