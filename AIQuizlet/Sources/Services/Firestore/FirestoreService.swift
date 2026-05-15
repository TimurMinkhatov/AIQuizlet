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
    
    private let database = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
}

// MARK: - Public Methods

extension FirestoreService {
    
    func createUser(email: String) async throws {
        guard let userId else { return }
        let document = try await database.collection("users").document(userId).getDocument()
        guard !document.exists else { return }
        
        let initialStats = UserStats.initial()
        let userData: [String: Any] = [
            "userId": userId,
            "email": email,
            "totalQuizzes": initialStats.totalQuizzes,
            "totalCompleted": initialStats.totalCompleted,
            "averageScore": initialStats.averageScore,
            "bestScore": initialStats.bestScore
        ]
        
        try await database.collection("users").document(userId).setData(userData)
    }
    
    func saveQuiz(quiz: FSQuiz) async throws {
        guard let userId else { return }
        try await database.collection("users").document(userId).collection("quizzes").document(quiz.id).setData(quiz.asDictionary)
    }
    
    func saveQuizResult(quizResult: FSQuizResult) async throws {
        guard let userId else { return }
        try await database.collection("users").document(userId).collection("quizResults").document(quizResult.id).setData(quizResult.asDictionary)
        
        try await updateUserStats(with: quizResult)
    }
    
    func fetchQuizzes() async throws -> [FSQuiz] {
        guard let userId else { return [] }
        let snapshot = try await database.collection("users").document(userId).collection("quizzes").getDocuments()
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
        
        let document = try await database.collection("users").document(userId).getDocument()
        guard let data = document.data() else { return nil }
        return try Firestore.Decoder().decode(FSUser.self, from: data)
    }
    
    func fetchUserStats() async throws -> UserStats? {
        guard let userId else { return nil }
        
        let document = try await database.collection("users").document(userId).getDocument()
        guard let data = document.data() else { return nil }
        return UserStats(from: data)
    }
    
    func listenToUserStats(completion: @escaping (UserStats?) -> Void) -> ListenerRegistration? {
        guard let userId else {
            completion(nil)
            return nil
        }
        
        return database.collection("users").document(userId).addSnapshotListener { snapshot, _ in
            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }
            let stats = UserStats(from: data)
            completion(stats)
        }
    }
    
    func fetchQuizResults() async throws -> [FSQuizResult] {
        guard let userId else { return []}
        
        let snapshot = try await database.collection("users").document(userId).collection("quizResults").getDocuments()
        return try snapshot.documents.compactMap {
            try Firestore.Decoder().decode(FSQuizResult.self, from: $0.data())
        }
    }
    
    func fetchUserQuizzes(userId: String) async throws -> [FSQuiz] {
        let snapshot = try await database.collection("users")
            .document(userId)
            .collection("quizzes")
            .getDocuments()
        var quizzes: [FSQuiz] = []
        
        for doc in snapshot.documents {
            do {
                var data = doc.data()
                
                if data["id"] == nil {
                    data["id"] = doc.documentID
                }
                let quiz = try Firestore.Decoder().decode(FSQuiz.self, from: data)
                quizzes.append(quiz)
            } catch {}
        }
        return quizzes
    }
    
    func fetchUserResults(userId: String) async throws -> [FSQuizResult] {
        let snapshot = try await database.collection("users")
            .document(userId)
            .collection("quizResults")
            .getDocuments()
        
        var results: [FSQuizResult] = []
        for doc in snapshot.documents {
            do {
                var data = doc.data()
                                
                if data["id"] == nil {
                    data["id"] = doc.documentID
                }
                let result = try Firestore.Decoder().decode(FSQuizResult.self, from: data)
                results.append(result)
            } catch {}
        }
        
        return results
    }
    
    func deleteQuizResult(resultId: String) async throws {
        guard let userId else { return }
        try await database.collection("users")
            .document(userId)
            .collection("quizResults")
            .document(resultId)
            .delete()
    }
    
    func deleteQuiz(quizId: String) async throws {
        guard let userId else { return }
        try await database.collection("users")
            .document(userId)
            .collection("quizzes")
            .document(quizId)
            .delete()
    }
    
    func deleteAllData() async throws {
        guard let userId else { return }
        
        let batch = database.batch()
        let quizzes = try await database.collection("users").document(userId).collection("quizzes").getDocuments()
        for doc in quizzes.documents {
            batch.deleteDocument(doc.reference)
        }
        
        let results = try await database.collection("users").document(userId).collection("quizResults").getDocuments()
        for doc in results.documents {
            batch.deleteDocument(doc.reference)
        }
        
        try await batch.commit()
        
        let initialStats = UserStats.initial()
        let userRef = database.collection("users").document(userId)
        try await userRef.updateData(initialStats.toDictionary())
    }
}

// MARK: - Private Methods

private extension FirestoreService {
    
    func updateUserStats(with result: FSQuizResult) async throws {
        guard let userId else { return }
        let userRef = database.collection("users").document(userId)
        
        _ = try await database.runTransaction { (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            do {
                try document = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let userData = document.data() else { return nil }
            
            let currentStats = UserStats(from: userData)
            
            let updatedStats = currentStats.updatedWith(newResult: result)
            
            transaction.updateData(updatedStats.toDictionary(), forDocument: userRef)
            
            return nil
        }
    }
}
