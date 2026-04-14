//
//  TabBarPage.swift
//  AIQuizlet
//
//  Created by Azamat Zakirov on 13.04.2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

enum TabBarPage: Int, CaseIterable {
    case home = 0
    case history = 1
    case profile = 2
    
    var pageTitle: String {
        switch self {
        case .home: return "Главная"
        case .history: return "История тестов"
        case .profile: return "Профиль"
        }
    }
    
    var pageIconName: String {
        switch self {
        case .home: return "house"
        case .history: return "clock"
        case .profile: return "person.crop.circle"
        }
    }
}
