//
//  MockFirebaseUser.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 11/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import FirebaseAuth
@testable import AIQuizlet

final class MockFirebaseUser: FirebaseAuth.User {
    private let mockUid: String
    
    init(uid: String) {
        self.mockUid = uid
    }
    
    override var uid: String { mockUid }
}
