// Generated using Sourcery 2.3.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Moya
@testable import AIQuizlet


// MARK: - MockAuthService

final class MockAuthService: AuthServiceProtocol {
    var currentUser: FirebaseAuth.User? = nil

    var currentUserId: String? = nil

    var requireUserIdThrowableError: Error?
    var requireUserIdCallCount = 0
    var requireUserIdReturnValue: String!

    func requireUserId(timeoutSeconds: TimeInterval) async throws -> String {
        requireUserIdCallCount += 1
        if let error = requireUserIdThrowableError { throw error }
        return requireUserIdReturnValue
    }

    var registerCallCount = 0

    func register(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        registerCallCount += 1
    }

    var signInCallCount = 0

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        signInCallCount += 1
    }

    var signOutCallCount = 0

    func signOut() {
        signOutCallCount += 1
    }

}

// MARK: - MockFirestoreService

final class MockFirestoreService: FirestoreServiceProtocol {
    var createUserThrowableError: Error?
    var createUserCallCount = 0

    func createUser(email: String) async throws {
        createUserCallCount += 1
        if let error = createUserThrowableError { throw error }
    }

    var saveQuizThrowableError: Error?
    var saveQuizCallCount = 0

    func saveQuiz(quiz: FSQuiz) async throws {
        saveQuizCallCount += 1
        if let error = saveQuizThrowableError { throw error }
    }

    var saveQuizResultThrowableError: Error?
    var saveQuizResultCallCount = 0

    func saveQuizResult(quizResult: FSQuizResult) async throws {
        saveQuizResultCallCount += 1
        if let error = saveQuizResultThrowableError { throw error }
    }

    var fetchQuizzesThrowableError: Error?
    var fetchQuizzesCallCount = 0
    var fetchQuizzesReturnValue: [FSQuiz]!

    func fetchQuizzes() async throws -> [FSQuiz] {
        fetchQuizzesCallCount += 1
        if let error = fetchQuizzesThrowableError { throw error }
        return fetchQuizzesReturnValue
    }

    var syncQuizzesThrowableError: Error?
    var syncQuizzesCallCount = 0
    var syncQuizzesReturnValue: [FSQuiz]!

    func syncQuizzes(localQuizzes: [QuizRecord]) async throws -> [FSQuiz] {
        syncQuizzesCallCount += 1
        if let error = syncQuizzesThrowableError { throw error }
        return syncQuizzesReturnValue
    }

    var fetchUserThrowableError: Error?
    var fetchUserCallCount = 0
    var fetchUserReturnValue: FSUser? = nil

    func fetchUser() async throws -> FSUser? {
        fetchUserCallCount += 1
        if let error = fetchUserThrowableError { throw error }
        return fetchUserReturnValue
    }

    var fetchUserStatsThrowableError: Error?
    var fetchUserStatsCallCount = 0
    var fetchUserStatsReturnValue: UserStats? = nil

    func fetchUserStats() async throws -> UserStats? {
        fetchUserStatsCallCount += 1
        if let error = fetchUserStatsThrowableError { throw error }
        return fetchUserStatsReturnValue
    }

    var listenToUserStatsCallCount = 0
    var listenToUserStatsReturnValue: ListenerRegistration? = nil

    func listenToUserStats(completion: @escaping (UserStats?) -> Void) -> ListenerRegistration? {
        listenToUserStatsCallCount += 1
        return listenToUserStatsReturnValue
    }

    var fetchQuizResultsThrowableError: Error?
    var fetchQuizResultsCallCount = 0
    var fetchQuizResultsReturnValue: [FSQuizResult]!

    func fetchQuizResults() async throws -> [FSQuizResult] {
        fetchQuizResultsCallCount += 1
        if let error = fetchQuizResultsThrowableError { throw error }
        return fetchQuizResultsReturnValue
    }

    var fetchUserQuizzesThrowableError: Error?
    var fetchUserQuizzesCallCount = 0
    var fetchUserQuizzesReturnValue: [FSQuiz]!

    func fetchUserQuizzes(userId: String) async throws -> [FSQuiz] {
        fetchUserQuizzesCallCount += 1
        if let error = fetchUserQuizzesThrowableError { throw error }
        return fetchUserQuizzesReturnValue
    }

    var fetchUserResultsThrowableError: Error?
    var fetchUserResultsCallCount = 0
    var fetchUserResultsReturnValue: [FSQuizResult]!

    func fetchUserResults(userId: String) async throws -> [FSQuizResult] {
        fetchUserResultsCallCount += 1
        if let error = fetchUserResultsThrowableError { throw error }
        return fetchUserResultsReturnValue
    }

    var deleteQuizResultThrowableError: Error?
    var deleteQuizResultCallCount = 0

    func deleteQuizResult(resultId: String) async throws {
        deleteQuizResultCallCount += 1
        if let error = deleteQuizResultThrowableError { throw error }
    }

    var deleteQuizThrowableError: Error?
    var deleteQuizCallCount = 0

    func deleteQuiz(quizId: String) async throws {
        deleteQuizCallCount += 1
        if let error = deleteQuizThrowableError { throw error }
    }

    var deleteAllDataThrowableError: Error?
    var deleteAllDataCallCount = 0

    func deleteAllData() async throws {
        deleteAllDataCallCount += 1
        if let error = deleteAllDataThrowableError { throw error }
    }

}

// MARK: - MockQuizService

final class MockQuizService: QuizServiceProtocol {
    var generateQuizThrowableError: Error?
    var generateQuizCallCount = 0
    var generateQuizReturnValue: Quiz!

    func generateQuiz(for text: String, count: Int) async throws -> Quiz {
        generateQuizCallCount += 1
        if let error = generateQuizThrowableError { throw error }
        return generateQuizReturnValue
    }

    var getQuizzesThrowableError: Error?
    var getQuizzesCallCount = 0
    var getQuizzesReturnValue: [Quiz]!

    func getQuizzes() async throws -> [Quiz] {
        getQuizzesCallCount += 1
        if let error = getQuizzesThrowableError { throw error }
        return getQuizzesReturnValue
    }

}

// MARK: - MockStorageService

final class MockStorageService: StorageServiceProtocol {
    var saveQuizResultThrowableError: Error?
    var saveQuizResultCallCount = 0

    func saveQuizResult(_ quizResult: QuizResult) throws {
        saveQuizResultCallCount += 1
        if let error = saveQuizResultThrowableError { throw error }
    }

    var fetchResultsThrowableError: Error?
    var fetchResultsCallCount = 0
    var fetchResultsReturnValue: [QuizResult]!

    func fetchResults() throws -> [QuizResult] {
        fetchResultsCallCount += 1
        if let error = fetchResultsThrowableError { throw error }
        return fetchResultsReturnValue
    }

    var fetchQuizzesThrowableError: Error?
    var fetchQuizzesCallCount = 0
    var fetchQuizzesReturnValue: [QuizRecord]!

    func fetchQuizzes() throws -> [QuizRecord] {
        fetchQuizzesCallCount += 1
        if let error = fetchQuizzesThrowableError { throw error }
        return fetchQuizzesReturnValue
    }

    var deleteAllThrowableError: Error?
    var deleteAllCallCount = 0

    func deleteAll() throws {
        deleteAllCallCount += 1
        if let error = deleteAllThrowableError { throw error }
    }

    var saveQuizThrowableError: Error?
    var saveQuizCallCount = 0

    func saveQuiz(_ quizRecord: QuizRecord) throws {
        saveQuizCallCount += 1
        if let error = saveQuizThrowableError { throw error }
    }

    var checkExistsThrowableError: Error?
    var checkExistsCallCount = 0
    var checkExistsReturnValue: Bool!

    func checkExists(id: String) throws -> Bool {
        checkExistsCallCount += 1
        if let error = checkExistsThrowableError { throw error }
        return checkExistsReturnValue
    }

    var saveCloudQuizThrowableError: Error?
    var saveCloudQuizCallCount = 0

    func saveCloudQuiz(_ fsQuiz: FSQuiz, userId: String) throws {
        saveCloudQuizCallCount += 1
        if let error = saveCloudQuizThrowableError { throw error }
    }

    var checkResultExistsThrowableError: Error?
    var checkResultExistsCallCount = 0
    var checkResultExistsReturnValue: Bool!

    func checkResultExists(id: String) throws -> Bool {
        checkResultExistsCallCount += 1
        if let error = checkResultExistsThrowableError { throw error }
        return checkResultExistsReturnValue
    }

    var saveCloudResultThrowableError: Error?
    var saveCloudResultCallCount = 0

    func saveCloudResult(_ fsResult: FSQuizResult, userId: String) throws {
        saveCloudResultCallCount += 1
        if let error = saveCloudResultThrowableError { throw error }
    }

}
