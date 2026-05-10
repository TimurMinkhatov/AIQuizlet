// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum Auth {
    /// Already have an account? Sign In
    public static var switchToLogin: String { return L10n.tr("Localizable", "auth.switchToLogin", fallback: "Already have an account? Sign In") }
    /// Don't have an account? Register
    public static var switchToRegister: String { return L10n.tr("Localizable", "auth.switchToRegister", fallback: "Don't have an account? Register") }
    public enum ConfirmPassword {
      /// Confirm Password
      public static var label: String { return L10n.tr("Localizable", "auth.confirmPassword.label", fallback: "Confirm Password") }
      /// Repeat password
      public static var placeholder: String { return L10n.tr("Localizable", "auth.confirmPassword.placeholder", fallback: "Repeat password") }
    }
    public enum Email {
      /// Email
      public static var label: String { return L10n.tr("Localizable", "auth.email.label", fallback: "Email") }
      /// example@email.com
      public static var placeholder: String { return L10n.tr("Localizable", "auth.email.placeholder", fallback: "example@email.com") }
    }
    public enum Error {
      /// Invalid email format
      public static var invalidEmail: String { return L10n.tr("Localizable", "auth.error.invalidEmail", fallback: "Invalid email format") }
      /// Passwords do not match
      public static var passwordMismatch: String { return L10n.tr("Localizable", "auth.error.passwordMismatch", fallback: "Passwords do not match") }
      /// Password must be at least 6 characters
      public static var weakPassword: String { return L10n.tr("Localizable", "auth.error.weakPassword", fallback: "Password must be at least 6 characters") }
    }
    public enum Login {
      /// Sign In
      public static var button: String { return L10n.tr("Localizable", "auth.login.button", fallback: "Sign In") }
      /// Sign in to your account
      public static var subtitle: String { return L10n.tr("Localizable", "auth.login.subtitle", fallback: "Sign in to your account") }
      /// Welcome Back!
      public static var title: String { return L10n.tr("Localizable", "auth.login.title", fallback: "Welcome Back!") }
    }
    public enum Password {
      /// Password
      public static var label: String { return L10n.tr("Localizable", "auth.password.label", fallback: "Password") }
      /// ······
      public static var placeholder: String { return L10n.tr("Localizable", "auth.password.placeholder", fallback: "······") }
      /// At least 6 characters
      public static var registerPlaceholder: String { return L10n.tr("Localizable", "auth.password.registerPlaceholder", fallback: "At least 6 characters") }
    }
    public enum Register {
      /// Register
      public static var button: String { return L10n.tr("Localizable", "auth.register.button", fallback: "Register") }
      /// Register to get started
      public static var subtitle: String { return L10n.tr("Localizable", "auth.register.subtitle", fallback: "Register to get started") }
      /// Create Account
      public static var title: String { return L10n.tr("Localizable", "auth.register.title", fallback: "Create Account") }
    }
  }
  public enum Common {
    /// Cancel
    public static var cancel: String { return L10n.tr("Localizable", "common.cancel", fallback: "Cancel") }
    /// Loading...
    public static var loading: String { return L10n.tr("Localizable", "common.loading", fallback: "Loading...") }
    /// OK
    public static var ok: String { return L10n.tr("Localizable", "common.ok", fallback: "OK") }
    public enum Error {
      /// No internet connection
      public static var noInternet: String { return L10n.tr("Localizable", "common.error.noInternet", fallback: "No internet connection") }
      /// Server error. Please try again
      public static var serverError: String { return L10n.tr("Localizable", "common.error.serverError", fallback: "Server error. Please try again") }
      /// Error
      public static var title: String { return L10n.tr("Localizable", "common.error.title", fallback: "Error") }
    }
  }
  public enum History {
    /// Test History
    public static var title: String { return L10n.tr("Localizable", "history.title", fallback: "Test History") }
    /// Home
    public static var toHome: String { return L10n.tr("Localizable", "history.toHome", fallback: "Home") }
    public enum Create {
      /// Create first test through the main screen!
      public static var first: String { return L10n.tr("Localizable", "history.create.first", fallback: "Create first test through the main screen!") }
    }
    public enum Item {
      /// %@ • %d questions
      public static func info(_ p1: Any, _ p2: Int) -> String {
        return L10n.tr("Localizable", "history.item.info", String(describing: p1), p2, fallback: "%@ • %d questions")
      }
    }
    public enum Questions {
      /// %d questions
      public static func count(_ p1: Int) -> String {
        return L10n.tr("Localizable", "history.questions.count", p1, fallback: "%d questions")
      }
    }
    public enum Search {
      /// You don't have tests
      public static var no: String { return L10n.tr("Localizable", "history.search.no", fallback: "You don't have tests") }
      /// Search by title...
      public static var placeholder: String { return L10n.tr("Localizable", "history.search.placeholder", fallback: "Search by title...") }
    }
  }
  public enum Home {
    /// Hello!
    public static var greeting: String { return L10n.tr("Localizable", "home.greeting", fallback: "Hello!") }
    public enum CreateFromPhoto {
      /// Take a photo of your notes and get a ready test
      public static var subtitle: String { return L10n.tr("Localizable", "home.createFromPhoto.subtitle", fallback: "Take a photo of your notes and get a ready test") }
      /// Create Test from Notes
      public static var title: String { return L10n.tr("Localizable", "home.createFromPhoto.title", fallback: "Create Test from Notes") }
    }
    public enum CreateFromText {
      /// Paste or enter your lecture text
      public static var subtitle: String { return L10n.tr("Localizable", "home.createFromText.subtitle", fallback: "Paste or enter your lecture text") }
      /// Create from Text
      public static var title: String { return L10n.tr("Localizable", "home.createFromText.title", fallback: "Create from Text") }
    }
    public enum Empty {
      /// Create your first one!
      public static var subtitle: String { return L10n.tr("Localizable", "home.empty.subtitle", fallback: "Create your first one!") }
      /// No tests yet
      public static var title: String { return L10n.tr("Localizable", "home.empty.title", fallback: "No tests yet") }
    }
    public enum Quiz {
      /// See all
      public static var watch: String { return L10n.tr("Localizable", "home.quiz.watch", fallback: "See all") }
    }
    public enum RecentQuizzes {
      /// Recent Tests
      public static var title: String { return L10n.tr("Localizable", "home.recentQuizzes.title", fallback: "Recent Tests") }
    }
  }
  public enum Profile {
    /// Profile
    public static var title: String { return L10n.tr("Localizable", "profile.title", fallback: "Profile") }
    /// Version %@
    public static func version(_ p1: Any) -> String {
      return L10n.tr("Localizable", "profile.version", String(describing: p1), fallback: "Version %@")
    }
    public enum DeleteData {
      /// Clear All Data
      public static var button: String { return L10n.tr("Localizable", "profile.deleteData.button", fallback: "Clear All Data") }
      /// Cancel
      public static var cancel: String { return L10n.tr("Localizable", "profile.deleteData.cancel", fallback: "Cancel") }
      /// Delete
      public static var confirmButton: String { return L10n.tr("Localizable", "profile.deleteData.confirmButton", fallback: "Delete") }
      /// This will delete all created tests and results. This action cannot be undone.
      public static var message: String { return L10n.tr("Localizable", "profile.deleteData.message", fallback: "This will delete all created tests and results. This action cannot be undone.") }
      /// Delete All Data?
      public static var title: String { return L10n.tr("Localizable", "profile.deleteData.title", fallback: "Delete All Data?") }
    }
    public enum Language {
      /// English
      public static var english: String { return L10n.tr("Localizable", "profile.language.english", fallback: "English") }
      /// Русский
      public static var russian: String { return L10n.tr("Localizable", "profile.language.russian", fallback: "Русский") }
      /// Language
      public static var title: String { return L10n.tr("Localizable", "profile.language.title", fallback: "Language") }
    }
    public enum Logout {
      /// Sign Out
      public static var button: String { return L10n.tr("Localizable", "profile.logout.button", fallback: "Sign Out") }
      /// Cancel
      public static var cancel: String { return L10n.tr("Localizable", "profile.logout.cancel", fallback: "Cancel") }
      /// Sign Out
      public static var confirmButton: String { return L10n.tr("Localizable", "profile.logout.confirmButton", fallback: "Sign Out") }
      /// You can sign in again at any time.
      public static var message: String { return L10n.tr("Localizable", "profile.logout.message", fallback: "You can sign in again at any time.") }
      /// Are you sure you want to sign out?
      public static var title: String { return L10n.tr("Localizable", "profile.logout.title", fallback: "Are you sure you want to sign out?") }
    }
    public enum Settings {
      /// Settings
      public static var title: String { return L10n.tr("Localizable", "profile.settings.title", fallback: "Settings") }
    }
    public enum Stats {
      /// Average Score
      public static var averageScore: String { return L10n.tr("Localizable", "profile.stats.averageScore", fallback: "Average Score") }
      /// Best Score
      public static var bestScore: String { return L10n.tr("Localizable", "profile.stats.bestScore", fallback: "Best Score") }
      /// Questions Solved
      public static var totalCompleted: String { return L10n.tr("Localizable", "profile.stats.totalCompleted", fallback: "Questions Solved") }
      /// Total Tests
      public static var totalQuizzes: String { return L10n.tr("Localizable", "profile.stats.totalQuizzes", fallback: "Total Tests") }
    }
    public enum Theme {
      /// Dark
      public static var dark: String { return L10n.tr("Localizable", "profile.theme.dark", fallback: "Dark") }
      /// Light
      public static var light: String { return L10n.tr("Localizable", "profile.theme.light", fallback: "Light") }
      /// System
      public static var system: String { return L10n.tr("Localizable", "profile.theme.system", fallback: "System") }
      /// Appearance
      public static var title: String { return L10n.tr("Localizable", "profile.theme.title", fallback: "Appearance") }
    }
  }
  public enum Quiz {
    /// Question
    public static var question: String { return L10n.tr("Localizable", "quiz.question", fallback: "Question") }
    public enum Answer {
      /// Option %@ — %@
      public static func option(_ p1: Any, _ p2: Any) -> String {
        return L10n.tr("Localizable", "quiz.answer.option", String(describing: p1), String(describing: p2), fallback: "Option %@ — %@")
      }
    }
    public enum Explanation {
      /// Correct answer based on the provided text.
      public static var `default`: String { return L10n.tr("Localizable", "quiz.explanation.default", fallback: "Correct answer based on the provided text.") }
      /// Explanation: 
      public static var title: String { return L10n.tr("Localizable", "quiz.explanation.title", fallback: "Explanation: ") }
    }
    public enum Finish {
      /// Finish Test
      public static var button: String { return L10n.tr("Localizable", "quiz.finish.button", fallback: "Finish Test") }
    }
    public enum Next {
      /// Next
      public static var button: String { return L10n.tr("Localizable", "quiz.next.button", fallback: "Next") }
    }
    public enum Photo {
      public enum Retake {
        /// Retake
        public static var button: String { return L10n.tr("Localizable", "quiz.photo.retake.button", fallback: "Retake") }
      }
    }
    public enum Question {
      /// Continue
      public static var `continue`: String { return L10n.tr("Localizable", "quiz.question.continue", fallback: "Continue") }
      /// Question %d of %d
      public static func counter(_ p1: Int, _ p2: Int) -> String {
        return L10n.tr("Localizable", "quiz.question.counter", p1, p2, fallback: "Question %d of %d")
      }
      /// Question %d: %@
      public static func title(_ p1: Int, _ p2: Any) -> String {
        return L10n.tr("Localizable", "quiz.question.title", p1, String(describing: p2), fallback: "Question %d: %@")
      }
    }
    public enum Result {
      /// Correct!
      public static var correct: String { return L10n.tr("Localizable", "quiz.result.correct", fallback: "Correct!") }
      /// Incorrect
      public static var incorrect: String { return L10n.tr("Localizable", "quiz.result.incorrect", fallback: "Incorrect") }
    }
    public enum TextInput {
      /// %d / %d characters
      public static func characterCount(_ p1: Int, _ p2: Int) -> String {
        return L10n.tr("Localizable", "quiz.textInput.characterCount", p1, p2, fallback: "%d / %d characters")
      }
      /// Generating...
      public static var generating: String { return L10n.tr("Localizable", "quiz.textInput.generating", fallback: "Generating...") }
      /// Minimum recommended length is 50 characters
      public static var minLength: String { return L10n.tr("Localizable", "quiz.textInput.minLength", fallback: "Minimum recommended length is 50 characters") }
      /// Paste lecture text, notes or textbook...
      public static var placeholder: String { return L10n.tr("Localizable", "quiz.textInput.placeholder", fallback: "Paste lecture text, notes or textbook...") }
      /// Number of questions
      public static var questionCount: String { return L10n.tr("Localizable", "quiz.textInput.questionCount", fallback: "Number of questions") }
      /// Enter text
      public static var title: String { return L10n.tr("Localizable", "quiz.textInput.title", fallback: "Enter text") }
      public enum Generate {
        /// Generate test
        public static var button: String { return L10n.tr("Localizable", "quiz.textInput.generate.button", fallback: "Generate test") }
      }
      public enum Paste {
        /// Paste
        public static var button: String { return L10n.tr("Localizable", "quiz.textInput.paste.button", fallback: "Paste") }
      }
    }
  }
  public enum Result {
    /// %d of %d correct answers
    public static func correctCount(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "result.correctCount", p1, p2, fallback: "%d of %d correct answers")
    }
    /// Test completed: %d of %d
    public static func end(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "result.end", p1, p2, fallback: "Test completed: %d of %d")
    }
    /// Good
    public static var good: String { return L10n.tr("Localizable", "result.good", fallback: "Good") }
    /// Great
    public static var great: String { return L10n.tr("Localizable", "result.great", fallback: "Great") }
    /// Could be better
    public static var notBad: String { return L10n.tr("Localizable", "result.notBad", fallback: "Could be better") }
    /// Perfect
    public static var perfect: String { return L10n.tr("Localizable", "result.perfect", fallback: "Perfect") }
    public enum Breakdown {
      /// Question Breakdown
      public static var title: String { return L10n.tr("Localizable", "result.breakdown.title", fallback: "Question Breakdown") }
    }
    public enum Home {
      /// Home
      public static var button: String { return L10n.tr("Localizable", "result.home.button", fallback: "Home") }
    }
    public enum TryAgain {
      /// Try Again
      public static var button: String { return L10n.tr("Localizable", "result.tryAgain.button", fallback: "Try Again") }
    }
  }
  public enum Splash {
    /// Create tests from your notes
    public static var subtitle: String { return L10n.tr("Localizable", "splash.subtitle", fallback: "Create tests from your notes") }
    /// Neural network
    ///  tutor
    public static var title: String { return L10n.tr("Localizable", "splash.title", fallback: "Neural network\n tutor") }
  }
  public enum TabBar {
    /// History
    public static var history: String { return L10n.tr("Localizable", "tabBar.history", fallback: "History") }
    /// Home
    public static var home: String { return L10n.tr("Localizable", "tabBar.home", fallback: "Home") }
    /// Profile
    public static var profile: String { return L10n.tr("Localizable", "tabBar.profile", fallback: "Profile") }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = LocalizationService.localizedString(key:table:fallbackValue:)(key, table, value)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}
