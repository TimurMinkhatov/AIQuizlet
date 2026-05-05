//
//  FirestoreService.swift
//  AIQuizlet
//
//  Created by Timur Minkhatov on 01/05/2026.
//  Copyright © 2026 t-bank-practice-team. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

final class FirestoreService {
    
    // MARK: Properties
    
    private let db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
}

// MARK: - Public Methods

extension FirestoreService {
    
    func createUser(email: String) async throws {
        guard let userId else { return }
        let document = try await db.collection("users").document(userId).getDocument()
        guard !document.exists else { return }
        
        let user = FSUser(
            userId: userId,
            email: email,
            totalQuizzes: 0,
            averageScore: 0.0,
            bestScore: 0.0,
            totalCompleted: 0
        )
        try await db.collection("users").document(userId).setData(user.asDictionary)
    }
    
    func saveQuiz(quiz: FSQuiz) async throws {
        guard let userId else { return }
        try await db.collection("users").document(userId).collection("quizzes").document(quiz.id).setData(quiz.asDictionary)
    }
    
    func saveQuizResult(quizResult: FSQuizResult) async throws {
        guard let userId else { return }
        try await db.collection("users").document(userId).collection("quizResults").document(quizResult.id).setData(quizResult.asDictionary)
        
        try await updateUserStats(result: quizResult)
    }
    
    func fetchQuizzes() async throws -> [FSQuiz] {
        guard let userId else { return [] }
        let snapshot = try await db.collection("users").document(userId).collection("quizzes").getDocuments()
        return try snapshot.documents.compactMap {
            try Firestore.Decoder().decode(FSQuiz.self, from: $0.data())
        }
    }
    
    func syncQuizzes(localQuizzes: [QuizRecord]) async throws -> [FSQuiz] {
        let remoteQuizzes = try await fetchQuizzes()
        
        if remoteQuizzes.count != localQuizzes.count {
            return remoteQuizzes
        }
        return []
    }
    
    func fetchUser() async throws -> FSUser? {
        guard let userId else { return nil }
        
        let document = try await db.collection("users").document(userId).getDocument()
        guard let data = document.data() else { return nil }
        return try Firestore.Decoder().decode(FSUser.self, from: data)
    }
    
    func listenToUserStats(completion: @escaping (FSUser?) -> Void) -> ListenerRegistration? {
        guard let userId else {
            completion(nil)
            return nil
        }
        
        return db.collection("users").document(userId).addSnapshotListener { snapshot, _ in
            guard let data = snapshot?.data(),
                  let user = try? Firestore.Decoder().decode(FSUser.self, from: data) else {
                completion(nil)
                return
            }
            completion(user)
        }
    }
    
    func fetchQuizResults() async throws -> [FSQuizResult] {
        guard let userId else { return []}
        
        let snapshot = try await db.collection("users").document(userId).collection("quizResults").getDocuments()
        return try snapshot.documents.compactMap {
            try Firestore.Decoder().decode(FSQuizResult.self, from: $0.data())
        }
    }
    
    func deleteAllData() async throws {
        guard let userId else { return }
        
        let batch = db.batch()
        let quizzes = try await db.collection("users").document(userId).collection("quizzes").getDocuments()
        for doc in quizzes.documents {
            batch.deleteDocument(doc.reference)
        }
        
        let results = try await db.collection("users").document(userId).collection("quizResults").getDocuments()
        for doc in results.documents {
            batch.deleteDocument(doc.reference)
        }
        
        try await batch.commit()
    }
}

// MARK: - Private Methods

private extension FirestoreService {
    
    func updateUserStats(result: FSQuizResult) async throws {
        guard let userId else { return }
        let userRef = db.collection("users").document(userId)
        
        let _ = try await db.runTransaction { (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let userData = document.data() else { return nil }
            
            let currentTotalQuizzes = userData["totalQuizzes"] as? Int ?? 0
            let currentTotalCompleted = userData["totalCompleted"] as? Int ?? 0
            let currentAvg = userData["averageScore"] as? Double ?? 0.0
            let currentBestScore = userData["bestScore"] as? Double ?? 0.0
            
            let newTotalQuizzes = currentTotalQuizzes + 1
            let newTotalCompleted = currentTotalCompleted + result.totalQuestions
            
            let newAvg = ((currentAvg * Double(currentTotalQuizzes)) + result.score) / Double(newTotalQuizzes)
            let newBestScore = max(currentBestScore, result.score)
            
            transaction.updateData([
                "totalQuizzes": newTotalQuizzes,
                "totalCompleted": newTotalCompleted,
                "averageScore": newAvg,
                "bestScore": newBestScore
            ], forDocument: userRef)
            
            return nil
        }
    }
}
